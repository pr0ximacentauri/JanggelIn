import 'dart:async';
import 'package:c3_ppl_agro/models/control.dart';
import 'package:c3_ppl_agro/models/services/control_service.dart';
import 'package:flutter/foundation.dart';

class ControlViewModel extends ChangeNotifier {
  final ControlService _controlService = ControlService();
  Control? _control;

  Control? get control => _control;
  bool get isOn => _control?.status == 'ON';

  ControlViewModel() {
    fetchControl();
  }

  Future<void> fetchControl() async {
    _control = await _controlService.fetchControl();
    notifyListeners();
  }

  Future<void> toggleControl() async {
    final newStatus = isOn ? 'OFF' : 'ON';
    final updatedControl = await _controlService.updateControlStatus(newStatus);

    if (updatedControl != null) {
      _control = updatedControl;
      notifyListeners();

      if (newStatus == 'ON') {
        Timer(Duration(seconds: 30), () async {
          final autoOffControl = await _controlService.updateControlStatus('OFF');
          if (autoOffControl != null) {
            _control = autoOffControl;
            notifyListeners();
          }
        });
      }
    } else {
      debugPrint("Gagal update status kontrol.");
    }
  }
}
