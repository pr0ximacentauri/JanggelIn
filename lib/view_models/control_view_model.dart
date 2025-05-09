import 'dart:async';
import 'package:c3_ppl_agro/models/control.dart';
import 'package:c3_ppl_agro/models/services/control_service.dart';
import 'package:c3_ppl_agro/models/services/mqtt_service.dart';
import 'package:flutter/foundation.dart';

class ControlViewModel with ChangeNotifier {
  final ControlService _controlService = ControlService();
  final MqttService _mqttService = MqttService();
  
  List<Control> _controls = [];
  List<Control> get controls => _controls;

  ControlViewModel() {
    getAllControls();
    _controlService.listenToAllControlChanges((updatedControl) {
      final index = _controls.indexWhere((control) => control.id == updatedControl.id);
      if (index != -1) {
        _controls[index] = updatedControl;
        notifyListeners();
      }
      _initMqtt();
    });
  } 

  Future<void> _initMqtt() async {
    await _mqttService.connect(onMessageReceived: (Map<String, dynamic> message){
      print("MQTT Message Received: $message");
    });
  }

  Future<void> getAllControls() async {
    _controls = await _controlService.fetchAllControls();
    notifyListeners();
  }

  Control getControlById(int id) {
    return _controls.firstWhere((control) => control.id == id, orElse: () => Control(id: id, name: 'Unknown', status: 'OFF', updatedAt: DateTime.now()));
  }

  Future<void> setControlStatus(int id, String newStatus) async {
    final updatedControl = await _controlService.updateControlStatusById(id, newStatus);

    if (updatedControl != null) {
      final index = _controls.indexWhere((control) => control.id == id);
      if (index != -1) {
        _controls[index] = updatedControl;
      } else {
        _controls.add(updatedControl);
      }
      notifyListeners();

      // await _mqttService.publish('kontrol/$id', newStatus);

      // auto off
      if (newStatus == 'ON') {
        Timer(Duration(seconds: 30), () async {
          final autoOffControl = await _controlService.updateControlStatusById(id,'OFF');
          if (autoOffControl != null) {
            final offIndex = _controls.indexWhere((control) => control.id == id);
            if (offIndex != -1) {
              _controls[offIndex] = autoOffControl;
              notifyListeners();

              // await _mqttService.publish('kontrol/$id', 'OFF');
            } 
          }
        });
      }
    } else {
      debugPrint("Gagal update status kontrol pada ID $id");
    }
  }
}
