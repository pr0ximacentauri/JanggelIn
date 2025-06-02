import 'package:flutter/material.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:c3_ppl_agro/models/services/sensor_service.dart';
import 'package:c3_ppl_agro/models/services/mqtt_service.dart';
import 'package:c3_ppl_agro/models/services/notification_service.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';

class SensorViewModel with ChangeNotifier {
  final SensorService _sensorService = SensorService();
  final MqttService _mqttService = MqttService();

  SensorData? _sensorData;
  List<SensorData> _sensorHistory = [];
  bool _wasOptimal = true;

  SensorData? get sensorData => _sensorData;
  double get temperature => _sensorData?.temperature ?? 0.0;
  double get humidity => _sensorData?.humidity ?? 0.0;
  List<SensorData> get sensorHistory => _sensorHistory;
  bool get hasSensorData => _sensorData != null;

  String get updatedAtFormatted {
    final updatedAt = _sensorData?.updatedAt;
    if (updatedAt == null) return 'Belum ada data sensor!';
    return 'Terakhir diperbarui: '
        '${updatedAt.day.toString().padLeft(2, '0')}-'
        '${updatedAt.month.toString().padLeft(2, '0')}-'
        '${updatedAt.year} '
        '${updatedAt.hour.toString().padLeft(2, '0')}:'
        '${updatedAt.minute.toString().padLeft(2, '0')}';
  }

  SensorViewModel() {
    getSensorData();
    getSensorHistory();
    _sensorService.listenToSensorUpdates((newData) {
      _sensorData = newData;
      notifyListeners();
    });
    _listenToMqttSensorData();
  }

  Future<void> getSensorData() async {
    _sensorData = await _sensorService.fetchLatestSensorData();
    notifyListeners();
  }

  Future<void> getSensorHistory() async {
    _sensorHistory = await _sensorService.fetchAllSensorData();
    notifyListeners();
  }

  void _listenToMqttSensorData() async {
    await _mqttService.connect(onSensorMessage: (data) async {
        final newSensorData = SensorData(
          id: 0,
          temperature: (data['temperature'] ?? 0.0).toDouble(),
          humidity: (data['humidity'] ?? 0.0).toDouble(),
          createdAt: _sensorData?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          fkOptimalLimit: _sensorData?.fkOptimalLimit,
        );

        _sensorData = newSensorData;
        notifyListeners();

        await _saveToDatabase();
      },
      onControlStatusChanged: (_) {},
    );
  }

  double? _lastSavedTemp;
  double? _lastSavedHumidity;

  Future<void> _saveToDatabase() async {
    if (_lastSavedTemp == null || _lastSavedHumidity == null ||
        (temperature - _lastSavedTemp!).abs() > 0.5 ||
        (humidity - _lastSavedHumidity!).abs() > 1.0) {
      await _sensorService.uploadSensorData(_sensorData!);
      _lastSavedTemp = temperature;
      _lastSavedHumidity = humidity;
    }
  }

  void checkOptimalStatus(OptimalLimitViewModel optimalVM) {
    if (_sensorData == null) return;

    final limit = optimalVM.getById(_sensorData!.fkOptimalLimit);
    if (limit == null) return;

    final isTempOptimal = optimalVM.isTemperatureOptimal(temperature, limit);
    final isHumidOptimal = optimalVM.isHumidityOptimal(humidity, limit);
    final isCurrentlyOptimal = isTempOptimal && isHumidOptimal;

    if (_wasOptimal != isCurrentlyOptimal) {
      _wasOptimal = isCurrentlyOptimal;
      if (!isCurrentlyOptimal) {
        NotificationService.showNotification(
          title: 'Kondisi Tidak Optimal',
          body: 'Suhu atau kelembapan berada di luar batas optimal!',
        );
      } else {
        NotificationService.showNotification(
          title: 'Kembali Optimal',
          body: 'Suhu dan kelembapan kini berada dalam batas optimal.',
        );
      }
    }
  }
}
