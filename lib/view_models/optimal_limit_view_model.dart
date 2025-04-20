import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/models/services/optimal_limit_service.dart';
import 'package:flutter/material.dart';

class OptimalLimitViewModel with ChangeNotifier {
  final OptimalLimitService _service = OptimalLimitService();
  OptimalLimit? _limit;

  OptimalLimit? get limit => _limit;

  OptimalLimitViewModel() {
    fetchOptimalLimit();
  }

  Future<void> fetchOptimalLimit() async {
    _limit = await _service.getOptimalLimit();
    notifyListeners();
  }

  bool isTemperatureOptimal(double temperature) {
    if (_limit == null) return true;
    return temperature >= _limit!.minTemperature && temperature <= _limit!.maxTemperature;
  }

  bool isHumidityOptimal(double humidity) {
    if (_limit == null) return true;
    return humidity >= _limit!.minHumidity && humidity <= _limit!.maxHumidity;
  }
  
}