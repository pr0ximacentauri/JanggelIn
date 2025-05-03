import 'package:c3_ppl_agro/models/control.dart';
import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/models/services/control_service.dart';
import 'package:c3_ppl_agro/models/services/optimal_limit_service.dart';
import 'package:flutter/foundation.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:c3_ppl_agro/models/services/sensor_service.dart';
import 'package:c3_ppl_agro/models/services/mqtt_service.dart';
import 'package:c3_ppl_agro/view_models/control_view_model.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:intl/intl.dart';

class SensorViewModel with ChangeNotifier {
  final SensorService _sensorService = SensorService();
  final OptimalLimitService _optimalLimitService = OptimalLimitService();
  final ControlService _controlService = ControlService();
  final MqttService _mqttService = MqttService();
  
  SensorData? _sensorData;
  final List<SensorData> _sensorHistory = [];
  final List<OptimalLimit> _optimalLimitHistory = [];
  final List<Control> _controlHistory = [];
  SensorData? get sensorData => _sensorData;
  bool get hasSensorData => _sensorData != null;
  double get temperature => _sensorData?.temperature ?? 0.0;
  double get humidity => _sensorData?.humidity ?? 0.0;
  List<SensorData> get sensorHistory => _sensorHistory;
  List<OptimalLimit> get optimalLimitHistory => _optimalLimitHistory;
  List<Control> get controlHistory => _controlHistory;

  // List<Map<String, dynamic>> get mergedHistory {
  //   return sensorHistory.map((sensor) {
  //     final String timestamp = DateFormat('dd-MM-yyyy HH:mm').format(sensor.updatedAt);

  //     final control = controlHistory.firstWhere(
  //       (c) => DateFormat('dd-MM-yyyy HH:mm').format(c.updatedAt) == timestamp,
  //       orElse: () => Control(
  //         id: 0,
  //         name: 'Unknown',
  //         status: 'Unknown',
  //         createdAt: sensor.createdAt,
  //         updatedAt: sensor.updatedAt,
  //       ),
  //     );

  //     final limit = optimalLimitHistory.firstWhere(
  //       (l) => DateFormat('dd-MM-yyyy HH:mm').format(l.updatedAt) == timestamp,
  //       orElse: () => OptimalLimit(
  //         id: 0,
  //         minTemperature: 0.0,
  //         maxTemperature: 0.0,
  //         minHumidity: 0.0,
  //         maxHumidity: 0.0,
  //         createdAt: sensor.updatedAt,
  //         updatedAt: sensor.updatedAt,
  //       ),
  //     );

  //     return {
  //       'timestamp': timestamp,
  //       'temperature': sensor.temperature,
  //       'humidity': sensor.humidity,
  //       'minTemp': limit.minTemperature,
  //       'maxTemp': limit.maxTemperature,
  //       'minHumid': limit.minHumidity,
  //       'maxHumid': limit.maxHumidity,
  //       'control': {
  //         'name': control.name,
  //         'status': control.status,
  //       }
  //     };
  //   }).toList();
  // }

  Future<List<Map<String, dynamic>>> mergedHistory(
    List<SensorData> sensorData,
    List<Control> controlData,
    List<OptimalLimit> limitData
  ) async {
    List<Map<String, dynamic>> mergedHistory = [];

    for (var sensor in sensorData) {
      final controlPompa = controlData.firstWhere(
        (c) => c.id == sensor.fkPompa,
        orElse: () => Control(id: 0, name: 'Pompa', status: 'OFF', updatedAt: DateTime.now()),
      );
      final controlKipas = controlData.firstWhere(
        (c) => c.id == sensor.fkKipas,
        orElse: () => Control(id: 0, name: 'Kipas', status: 'OFF', updatedAt: DateTime.now()),
      );
      final controlLampu = controlData.firstWhere(
        (c) => c.id == sensor.fkLampu,
        orElse: () => Control(id: 0, name: 'Lampu', status: 'OFF', updatedAt: DateTime.now()),
      );

      final limit = limitData.firstWhere(
        (l) => l.id == sensor.fkOptimalLimit,
        // orElse: () => OptimalLimit.defaultLimit(),
      );

      mergedHistory.add({
        'timestamp': sensor.updatedAt.toString(),
        'temperature': sensor.temperature,
        'humidity': sensor.humidity,
        'lampu': controlLampu.status,
        'kipas': controlKipas.status,
        'pompa': controlPompa.status,
        'minTemp': limit.minTemperature,
        'maxTemp': limit.maxTemperature,
        'minHumid': limit.minHumidity,
        'maxHumid': limit.maxHumidity,
      });
    }

    return mergedHistory;
  }



  SensorViewModel() {
    getSensorData();
    getSensorHistory();
    getOptimalLimitHistory();
    getControlHistory();
    _sensorService.listenToSensorUpdates((newData) {
      _sensorData = newData;
      notifyListeners();
    });
    // listenToMqttSensorData();
  }

  Future<void> initializeData() async {
    await getSensorData();
    await getSensorHistory();
    await getOptimalLimitHistory();
    await getControlHistory();
  }


  Future<void> getSensorData() async {
    _sensorData = await _sensorService.fetchLatestSensorData();
    notifyListeners();
  }
  Future<List<SensorData>> getSensorHistory() async {
    final response = await _sensorService.fetchAllSensorData();
    _sensorHistory.clear();
    _sensorHistory.addAll(response);
    return response;
  }
  Future<List<OptimalLimit>> getOptimalLimitHistory() async {
    final response = await _optimalLimitService.fetchAllOptimalLimits();
    _optimalLimitHistory.clear();
    _optimalLimitHistory.addAll(response);
    return response;
  }
  Future<List<Control>> getControlHistory() async {
    final response = await _controlService.fetchAllControls();
    _controlHistory.clear();
    _controlHistory.addAll(response);
    return response;
  }


  Future<void> setSensorOptimalLimit(int optimalLimitId) async {
    if (_sensorData == null) return;

    await _sensorService.updateSensorOptimalLimit(
      sensorId: _sensorData!.id,
      optimalLimitId: optimalLimitId,
    );
    
    _sensorData = SensorData(
      id: _sensorData!.id,
      temperature: _sensorData!.temperature,
      humidity: _sensorData!.humidity,
      createdAt: _sensorData!.createdAt,
      updatedAt: DateTime.now(),
      fkOptimalLimit: optimalLimitId,
    );

    notifyListeners();
  }


  Future<void> actuatorControl(OptimalLimitViewModel optimalVM, ControlViewModel controlVM) async {
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
