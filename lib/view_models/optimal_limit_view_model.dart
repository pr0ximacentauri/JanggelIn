import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/models/services/optimal_limit_service.dart';
import 'package:flutter/material.dart';

class OptimalLimitViewModel with ChangeNotifier {
  final OptimalLimitService _optimalLimitervice = OptimalLimitService();
  
  OptimalLimit? _limit;
  List<OptimalLimit> _limits = [];
  OptimalLimit? _selectedLimit;
  OptimalLimit? get limit => _limit;
  List<OptimalLimit> get limits => _limits;
  OptimalLimit? get selectedLimit => _selectedLimit;

  OptimalLimitViewModel() {
    getOptimalLimit();
    getAllOptimalLimits();
  }

  Future<void> getOptimalLimit() async {
    _limit = await _optimalLimitervice.fetchOptimalLimit();
    notifyListeners();
  }

  Future<void> getAllOptimalLimits() async {
    _limits = await _optimalLimitervice.fetchAllOptimalLimits();
    if (_limits.isNotEmpty) {
      _selectedLimit = _limits.first;
    }
    notifyListeners();
  }

  void setSelectedLimit(OptimalLimit limit) {
    _selectedLimit = limit;
    notifyListeners();
  }

  Future<void> updateOptimalLimit({
    required double minTemperature,
    required double maxTemperature,
    required double minHumidity,
    required double maxHumidity,
  }) async {
    await _optimalLimitervice.insertOptimalLimit(
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      minHumidity: minHumidity,
      maxHumidity: maxHumidity,
    );

    await getOptimalLimit();
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