import 'package:flutter/foundation.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:c3_ppl_agro/models/services/sensor_service.dart';
import 'package:c3_ppl_agro/models/services/mqtt_service.dart';
import 'package:c3_ppl_agro/view_models/control_view_model.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';

class SensorViewModel with ChangeNotifier {
  final SensorService _sensorService = SensorService();
  final MqttService _mqttService = MqttService();
  SensorData? _sensorData;

  SensorData? get sensorData => _sensorData;
  bool get hasSensorData => _sensorData != null;
  double get temperature => _sensorData?.temperature ?? 0.0;
  double get humidity => _sensorData?.humidity ?? 0.0;


  SensorViewModel() {
    getSensorData();
    _sensorService.listenToSensorUpdates((newData) {
      _sensorData = newData;
      notifyListeners();
    });
    // listenToMqttSensorData();
  }

  Future<void> getSensorData() async {
    _sensorData = await _sensorService.fetchLatestSensorData();
    notifyListeners();
  }

  Future<void> actuatorControl(
    OptimalLimitViewModel optimalVM,
    ControlViewModel controlVM,
  ) async {
    if (_sensorData == null || optimalVM.limit == null) return;

    final limit = optimalVM.limit!;
    final temp = temperature;
    final humid = humidity;

    // lampu pijar(3), kipas(2), pompa air(1)
    if (temp < limit.minTemperature) {
      await controlVM.setControlStatus(3, 'ON');
    }else if (temp > limit.maxTemperature) {
      await controlVM.setControlStatus(2, 'ON');
    }

    if (humid < limit.minHumidity) {
      await controlVM.setControlStatus(1, 'ON');
    }
  }

  // void listenToMqttSensorData() async {
  //   await _mqttService.connect(onMessageReceived: (data) async {
  //     _sensorData = SensorData(
  //       id: 0,
  //       temperature: (data['temperature'] ?? 0.0).toDouble(),
  //       humidity: (data['humidity'] ?? 0.0).toDouble(),
  //       updatedAt: DateTime.now(),
  //     );

  //     notifyListeners();

  //     // Simpan ke database hanya jika perlu
  //     await saveToDatabase();
  //   });
  // }

  // double? _lastSavedTemp;
  // double? _lastSavedHumidity;

  // Future<void> saveToDatabase() async {
  //   if (_lastSavedTemp == null || _lastSavedHumidity == null ||
  //       (temperature - _lastSavedTemp!).abs() > 0.5 ||
  //       (humidity - _lastSavedHumidity!).abs() > 1.0) {
  //     await _sensorService.uploadSensorData(_sensorData!);

  //     _lastSavedTemp = temperature;
  //     _lastSavedHumidity = humidity;
  //   }
  // }

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

}
