import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:c3_ppl_agro/models/services/sensor_service.dart';
import 'package:flutter/foundation.dart';

class SensorViewModel with ChangeNotifier {
  final SensorService _sensorService = SensorService();
  SensorData? _sensorData;

  SensorData? get sensorData => _sensorData;

  SensorViewModel() {
    fetchSensorData();
  }

  Future<void> fetchSensorData() async {
    _sensorData = await _sensorService.fetchLatestSensorData();
    notifyListeners();
  }

  double get temperature => _sensorData?.temperature ?? 0.0;
  double get humidity => _sensorData?.humidity ?? 0.0;
}
