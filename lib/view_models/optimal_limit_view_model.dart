import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/services/mqtt_service.dart';
import 'package:c3_ppl_agro/services/optimal_limit_service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';  

class OptimalLimitViewModel with ChangeNotifier {
  final OptimalLimitService _optimalLimitService = OptimalLimitService();
  final MqttService _mqttService = MqttService();

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

  Future<void> publishSelectedLimit() async {
  if (!_selectedLimitIsValid()) {
    debugPrint('Tidak ada batas optimal yang valid untuk dipublish');
    return;
  }

  if (_mqttService.isConnected) {
    await _mqttService.publishOptimalLimit(
      minTemperature: _selectedLimit!.minTemperature,
      maxTemperature: _selectedLimit!.maxTemperature,
      minHumidity: _selectedLimit!.minHumidity,
      maxHumidity: _selectedLimit!.maxHumidity,
    );
  } else {
    debugPrint('⚠️ MQTT belum terhubung');
  }
}

bool _selectedLimitIsValid() {
  return _selectedLimit != null;
}

  Future<void> getOptimalLimit() async {
    _limit = await _optimalLimitService.fetchOptimalLimit();
    notifyListeners();
  }

  Future<void> getAllOptimalLimits() async {
    _limits = await _optimalLimitService.fetchAllOptimalLimits();
    if (_limits.isNotEmpty) {
      _selectedLimit = _limits.first;
    }
    notifyListeners();
  }


  void setSelectedLimit(OptimalLimit? limit) {
    _selectedLimit = limit;
    notifyListeners();
  }

  OptimalLimit? getById(int? id) {
    return limits.firstWhereOrNull((opt) => opt.id == id);
  }

  void syncSelectedLimitWithSensor(int? fkOptimalLimit) {
    _selectedLimit = getById(fkOptimalLimit);
    notifyListeners();
  }

  Future<void> updateOptimalLimit({
    required double minTemperature,
    required double maxTemperature,
    required double minHumidity,
    required double maxHumidity,
  }) async {
    final current = _selectedLimit;

    if (current != null &&
        current.minTemperature == minTemperature &&
        current.maxTemperature == maxTemperature &&
        current.minHumidity == minHumidity &&
        current.maxHumidity == maxHumidity) {
      return;
    }
    await _optimalLimitService.insertOptimalLimit(
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      minHumidity: minHumidity,
      maxHumidity: maxHumidity,
    );

    await getOptimalLimit();
    await getAllOptimalLimits(); 
  } 

  Future<void> deleteOptimalLimit(int id) async {
    await _optimalLimitService.deleteOptimalLimit(id);

    limits.removeWhere((limit) => limit.id == id);
    if (selectedLimit?.id == id) {
      _selectedLimit = null;
    }

    notifyListeners();
  }

  void updateSelectedLimitAfterDeletion(List<OptimalLimit> limits) {
    if (selectedLimit != null && !limits.any((limit) => limit.id == selectedLimit!.id)) {
      if (limits.isNotEmpty) {
        setSelectedLimit(limits.first);
        publishSelectedLimit();
      } else {
        setSelectedLimit(null);
      }
    }
  }


  bool isTemperatureOptimal(double temperature, OptimalLimit limit) {
    // if (_limit == null) return true;
    return temperature >= limit.minTemperature && temperature <= limit.maxTemperature;
  }

  bool isHumidityOptimal(double humidity, OptimalLimit limit) {
    // if (_limit == null) return true;
    return humidity >= limit.minHumidity && humidity <= limit.maxHumidity;
  }
  
}