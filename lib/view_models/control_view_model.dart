import 'package:c3_ppl_agro/models/control.dart';
import 'package:flutter/material.dart';

class ControlViewModel extends ChangeNotifier {
  Control _control = Control(id: "JGL1", status: false);

  Control get control => _control;

  void toggleControl() {
    notifyListeners();
  }
  
}
