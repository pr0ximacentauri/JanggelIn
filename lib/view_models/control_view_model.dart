import 'dart:async';
import 'package:c3_ppl_agro/models/control.dart';
import 'package:c3_ppl_agro/models/services/control_service.dart';
import 'package:flutter/foundation.dart';

class ControlViewModel with ChangeNotifier {
  final ControlService _controlService = ControlService();
  List<Control> _controls = [];
  
  List<Control> get controls => _controls;

  ControlViewModel() {
    fetchAllControls();
  }

  Future<void> fetchAllControls() async {
    _controls = await _controlService.fetchAllControls();
    notifyListeners();
  }

  Control? getControlById(int id) {
    return _controls.firstWhere((control) => control.id == id, orElse: () => Control(id: id, status: 'OFF'));
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

      // auto off
      if (newStatus == 'ON') {
        Timer(Duration(seconds: 30), () async {
          final autoOffControl = await _controlService.updateControlStatusById(id,'OFF');
          if (autoOffControl != null) {
            final offIndex = _controls.indexWhere((control) => control.id == id);
            if (offIndex != -1) {
              _controls[offIndex] = autoOffControl;
              notifyListeners();
            } 
          }
        });
      }
    } else {
      debugPrint("Gagal update status kontrol pada ID $id");
    }
  }
}
