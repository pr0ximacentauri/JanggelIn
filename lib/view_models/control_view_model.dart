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
      print("MQTT Diterima: $message");
    }); 
  }

  Future<void> getAllControls() async {
    _controls = await _controlService.fetchAllControls();
    notifyListeners();
  }

  Control getControlById(int id) {
    return _controls.firstWhere((control) => control.id == id, orElse: () => Control(id: id, name: 'Unknown', status: 'OFF', updatedAt: DateTime.now()));
  }

  // Future<void> setControlStatus(int id, String newStatus) async {
  //   final index = _controls.indexWhere((control) => control.id == id);

  //   // Cek apakah status sudah sesuai, jika ya maka tidak perlu update
  //   if (index != -1 && _controls[index].status == newStatus) {
  //     debugPrint("Kontrol ID $id sudah bernilai $newStatus, skip update.");
  //     return;
  //   }

  //   final updatedControl = await _controlService.updateControlStatusById(id, newStatus);

  //   if (updatedControl != null) {
  //     if (index != -1) {
  //       _controls[index] = updatedControl;
  //     } else {
  //       _controls.add(updatedControl);
  //     }
  //     notifyListeners();

  //     // await _mqttService.publish('kontrol/$id', newStatus);

  //     // Auto off setelah 30 detik hanya jika benar-benar baru dinyalakan
  //     if (newStatus == 'ON') {
  //       Timer(Duration(seconds: 30), () async {
  //         final current = _controls.firstWhere((c) => c.id == id, orElse: () => updatedControl);
  //         if (current.status == 'ON') {
  //           final autoOffControl = await _controlService.updateControlStatusById(id, 'OFF');
  //           if (autoOffControl != null) {
  //             final offIndex = _controls.indexWhere((control) => control.id == id);
  //             if (offIndex != -1) {
  //               _controls[offIndex] = autoOffControl;
  //               notifyListeners();

  //               // await _mqttService.publish('kontrol/$id', 'OFF');
  //             }
  //           }
  //         }
  //       });
  //     }
  //   } else {
  //     debugPrint("Gagal update status kontrol pada ID $id");
  //   }
  // }

   Future<void> _publishToDevice(int id, String status) async {
    if(!_mqttService.isConnected) return; 
    await _mqttService.publishRelay(relayId: id, state: status);
  }


  Future<void> setControlStatus(int id, String newStatus) async {
    final index = _controls.indexWhere((c) => c.id == id);
    if (index != -1 && _controls[index].status == newStatus) return;

    final updated = await _controlService.updateControlStatusById(id, newStatus);
    if (updated == null) {
      debugPrint("Gagal update status kontrol pada ID $id");
      return;
    }

    if (index != -1) {
      _controls[index] = updated;
    } else {
      _controls.add(updated);
    }
    notifyListeners();

    await _publishToDevice(id, newStatus);

    if (newStatus == 'ON') {
      Timer(const Duration(seconds: 30), () async {
        final current = _controls.firstWhere((c) => c.id == id, orElse: () => updated);
        if (current.status == 'ON') {
          final off = await _controlService.updateControlStatusById(id, 'OFF');
          if (off != null) {
            final i = _controls.indexWhere((c) => c.id == id);
            if (i != -1) {
              _controls[i] = off;
              notifyListeners();
              await _publishToDevice(id, 'OFF'); 
            }
          }
        }
      });
    }
  }
}
