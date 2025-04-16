import 'dart:math';
import 'package:c3_ppl_agro/models/control.dart';
import 'package:flutter/material.dart';

class ControlViewModel extends ChangeNotifier {
  Control _sensor = Control(id: "JGL1");

  Control get device => _sensor;

  void toggleDevice() {
    notifyListeners();
  }

  // void updateSensorData() {
  //   _sensor.temperature = Random().nextDouble() * 10 + 25; 
  //   _sensor.humidity = Random().nextDouble() * 20 + 60; 
  //   notifyListeners();
  // }
}
