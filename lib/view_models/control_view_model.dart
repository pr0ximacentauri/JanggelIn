import 'dart:async';
import 'package:c3_ppl_agro/models/control.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:c3_ppl_agro/models/services/control_service.dart';
import 'package:flutter/foundation.dart';

class ControlViewModel with ChangeNotifier {
  final ControlService _controlService = ControlService();
  
  List<Control> _controls = [];
  List<Control> get controls => _controls;
  List<SensorData> _sensors = [];
  List<SensorData> get sensors => _sensors;

  ControlViewModel() {
    getAllControls();
    _controlService.listenToAllControlChanges((updatedControl) {
      final index = _controls.indexWhere((control) => control.id == updatedControl.id);
      if (index != -1) {
        _controls[index] = updatedControl;
        notifyListeners();
      }
    });
  } 

  Future<void> getAllControls() async {
    _controls = await _controlService.fetchAllControls();
    notifyListeners();
  }

  // Control getControlById(int id) {
  //   return _controls.firstWhere((control) => control.id == id, orElse: () => Control(id: id, name: 'Unknown', status: 'OFF', updatedAt: DateTime.now()));
  // }

  // Future<void> setControlStatus(int id, String newStatus) async {
  //   final updatedControl = await _controlService.updateControlStatusById(id, newStatus);

  //   if (updatedControl != null) {
  //     final index = _controls.indexWhere((control) => control.id == id);
  //     if (index != -1) {
  //       _controls[index] = updatedControl;
  //     } else {
  //       _controls.add(updatedControl);
  //     }
  //     notifyListeners();

  //     // auto off
  //     if (newStatus == 'ON') {
  //       Timer(Duration(seconds: 30), () async {
  //         final autoOffControl = await _controlService.updateControlStatusById(id,'OFF');
  //         if (autoOffControl != null) {
  //           final offIndex = _controls.indexWhere((control) => control.id == id);
  //           if (offIndex != -1) {
  //             _controls[offIndex] = autoOffControl;
  //             notifyListeners();
  //           } 
  //         }
  //       });
  //     }
  //   } else {
  //     debugPrint("Gagal update status kontrol pada ID $id");
  //   }
  // }


  Future<void> setPumpStatus(String newStatus) async {
    final pumpControl = await _controlService.updatePumpStatusById(newStatus);
    if (pumpControl != null) {
      final index = _sensors.indexWhere((control) => control.id == pumpControl.id);
      if (index != -1) {
        _sensors[index] = pumpControl;
      } else {
        _sensors.add(pumpControl);
      }
      notifyListeners();
      // auto off
      if (newStatus == 'ON') {
        Timer(Duration(seconds: 30), () async {
          final autoOffControl = await _controlService.updatePumpStatusById('OFF');
          if (autoOffControl != null) {
            final offIndex = _sensors.indexWhere((control) => control.id == autoOffControl.id);
            if (offIndex != -1) {
              _sensors[offIndex] = autoOffControl;
              notifyListeners();
            } 
          }
        });
      }
    } else {
      debugPrint("Gagal update status kontrol pada pompa");
    }
  }
   Future<void> setFanStatus(String newStatus) async {
    final fanControl = await _controlService.updateFanStatusById(newStatus);
    if (fanControl != null) {
      final index = _sensors.indexWhere((control) => control.id == fanControl.id);
      if (index != -1) {
        _sensors[index] = fanControl;
      } else {
        _sensors.add(fanControl);
      }
      notifyListeners();
      // auto off
      if (newStatus == 'ON') {
        Timer(Duration(seconds: 30), () async {
          final autoOffControl = await _controlService.updateFanStatusById('OFF');
          if (autoOffControl != null) {
            final offIndex = _sensors.indexWhere((control) => control.id == autoOffControl.id);
            if (offIndex != -1) {
              _sensors[offIndex] = autoOffControl;
              notifyListeners();
            } 
          }
        });
      }
    } else {
      debugPrint("Gagal update status kontrol pada pompa");
    }
  }
   Future<void> setLampStatus(String newStatus) async {
    final lampControl = await _controlService.updateLamptatusById(newStatus);
    if (lampControl != null) {
      final index = _sensors.indexWhere((control) => control.id == lampControl.id);
      if (index != -1) {
        _sensors[index] = lampControl;
      } else {
        _sensors.add(lampControl);
      }
      notifyListeners();
    } else {
      debugPrint("Gagal update status kontrol pada pompa");
    }
  }
}
