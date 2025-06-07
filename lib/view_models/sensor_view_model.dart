import 'dart:async';

import 'package:c3_ppl_agro/services/mqtt_service.dart';
import 'package:c3_ppl_agro/services/notification_service.dart';
import 'package:c3_ppl_agro/services/sensor_service.dart';
import 'package:flutter/material.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';

class SensorViewModel with ChangeNotifier {
  final SensorService _sensorService = SensorService();
  final MqttService _mqttService = MqttService();
  final OptimalLimitViewModel optimalLimitVM = OptimalLimitViewModel();

  SensorData? _sensorData;
  List<SensorData> _sensorHistory = [];
  bool _wasOptimal = true;

  DateTime? _lastMqttUpdate;
  final Duration _mqttTimeout = Duration(minutes: 2);
  Timer? _timeoutChecker;

  SensorData? get sensorData => _sensorData;
  double get temperature => _sensorData?.temperature ?? 0.0;
  double get humidity => _sensorData?.humidity ?? 0.0;
  List<SensorData> get sensorHistory => _sensorHistory;
  bool get hasSensorData => _sensorData != null;

  bool get isSensorOnline {
    if (_lastMqttUpdate == null) return false;
    return DateTime.now().difference(_lastMqttUpdate!) <= _mqttTimeout;
  }

  String get updatedAtFormatted {
    if (isSensorOnline == false) return 'Belum ada data sensor!';
    final updatedAt = _sensorData?.updatedAt;
    if (updatedAt == null) return 'Belum ada data sensor saat terbaru!';
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
    _startTimeoutChecker();
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
      final selectedLimitId = optimalLimitVM.selectedLimit?.id;
        final newSensorData = SensorData(
          id: 0,
          temperature: (data['temperature'] ?? 0.0).toDouble(),
          humidity: (data['humidity'] ?? 0.0).toDouble(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          fkOptimalLimit: selectedLimitId,
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

    final limit = optimalVM.selectedLimit;
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

  void _startTimeoutChecker() {
    _timeoutChecker = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_lastMqttUpdate == null) return;

      final now = DateTime.now();
      final difference = now.difference(_lastMqttUpdate!);

      if (difference > _mqttTimeout) {
        if (_sensorData != null) {
          _sensorData = null;
          notifyListeners();
        }
      }
    });
  }

  @override
  void dispose() {
    _timeoutChecker?.cancel();
    super.dispose();
  }
}
