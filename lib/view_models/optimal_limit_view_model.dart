import 'package:JanggelIn/models/optimal_limit.dart';
import 'package:JanggelIn/services/mqtt_service.dart';
import 'package:JanggelIn/services/optimal_limit_service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';  

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
    loadSelectedLimit(); 
  }

  Future<void> loadSelectedLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('selected_optimal_limit_id');

    if (savedId != null && _limits.isNotEmpty) {
      final matched = _limits.firstWhereOrNull((limit) => limit.id == savedId);
      if (matched != null) {
        _selectedLimit = matched;
        notifyListeners();
        debugPrint('Selected limit loaded: ID ${matched.id}');
      }
    }
  }

  Future<void> saveSelectedLimit(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_optimal_limit_id', id);
  }

  void setSelectedLimit(OptimalLimit? limit) {
    _selectedLimit = limit;
    notifyListeners();
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
      debugPrint('MQTT belum terhubung');
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
    notifyListeners();

    await loadSelectedLimit();
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selected_optimal_limit_id');
    }

    notifyListeners();
  }

  void updateSelectedLimitAfterDeletion(List<OptimalLimit> limits) async {
    final prefs = await SharedPreferences.getInstance();

    if (selectedLimit != null &&
        !limits.any((limit) => limit.id == selectedLimit!.id)) {
      if (limits.isNotEmpty) {
        setSelectedLimit(limits.first);
        await saveSelectedLimit(limits.first.id);
        await publishSelectedLimit();
      } else {
        setSelectedLimit(null);
        await prefs.remove('selected_optimal_limit_id');
      }
    }
  }

  bool isTemperatureOptimal(double temperature, OptimalLimit limit) {
    return temperature >= limit.minTemperature && temperature <= limit.maxTemperature;
  }

  bool isHumidityOptimal(double humidity, OptimalLimit limit) {
    return humidity >= limit.minHumidity && humidity <= limit.maxHumidity;
  }
}
