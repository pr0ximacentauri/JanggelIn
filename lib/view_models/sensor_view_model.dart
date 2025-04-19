import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorViewModel with ChangeNotifier{
  SensorData _sensorData = SensorData(id: 1, temperature: 30.0, humidity: 70.0, createdAt: DateTime.now(), updatedAt: DateTime.now());
  OptimalLimit _optimalLimit = OptimalLimit(
    id: 1,
    minTemperature: 23.0,
    maxTemperature: 36.0,
    minHumidity: 20.0,
    maxHumidity: 80.0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  SensorData get sensorData => _sensorData;
  OptimalLimit get optimalLimit => _optimalLimit;

  void updateSensorData(SensorData newSensorData) {
    _sensorData = newSensorData;
    notifyListeners();
  }

  void updateOptimalLimit(OptimalLimit newOptimalLimit) {
    _optimalLimit = newOptimalLimit;
    notifyListeners();
  }

  double getTemperature (){
    return((_sensorData.temperature - _optimalLimit.minTemperature) / (_optimalLimit.maxTemperature - _optimalLimit.minTemperature))
          .clamp(0.0, 1.0); 
  }

  double getHumidity (){
    return((_sensorData.humidity - _optimalLimit.minHumidity) / (_optimalLimit.maxHumidity - _optimalLimit.minHumidity))
          .clamp(0.0, 1.0); 
  }
}