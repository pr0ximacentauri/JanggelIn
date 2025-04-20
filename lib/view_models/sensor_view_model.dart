import 'package:flutter/foundation.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:c3_ppl_agro/models/services/sensor_service.dart';
import 'package:c3_ppl_agro/view_models/control_view_model.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';

class SensorViewModel with ChangeNotifier {
  final SensorService _sensorService = SensorService();
  SensorData? _sensorData;

  SensorData? get sensorData => _sensorData;

  double get temperature => _sensorData?.temperature ?? 0.0;
  double get humidity => _sensorData?.humidity ?? 0.0;

  SensorViewModel() {
    fetchSensorData();
    _sensorService.listenToSensorUpdates((newData) {
      _sensorData = newData;
      notifyListeners();
    });
  }

  Future<void> fetchSensorData() async {
    _sensorData = await _sensorService.fetchLatestSensorData();
    notifyListeners();
  }

  Future<void> evaluateAndControl(
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

  String get updatedAtFormatted {
  final updatedAt = _sensorData?.updatedAt;
  if (updatedAt == null) return 'Memuat...';

    return 'Terakhir diperbarui: '
        '${updatedAt.day.toString().padLeft(2, '0')}-'
        '${updatedAt.month.toString().padLeft(2, '0')}-'
        '${updatedAt.year} '
        '${updatedAt.hour.toString().padLeft(2, '0')}:'
        '${updatedAt.minute.toString().padLeft(2, '0')}';
  }
}
