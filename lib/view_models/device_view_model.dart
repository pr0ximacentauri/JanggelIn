import 'dart:math';
import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceViewModel extends ChangeNotifier {
  Device _device = Device(id: "jamur_01");

  Device get device => _device;

  void toggleDevice() {
    _device.status = !_device.status;
    notifyListeners();
  }

  void updateSensorData() {
    _device.temperature = Random().nextDouble() * 10 + 25; // 25 - 35°C
    _device.humidity = Random().nextDouble() * 20 + 60; // 60 - 80%
    notifyListeners();
  }
}
