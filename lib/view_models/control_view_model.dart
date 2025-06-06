import 'package:c3_ppl_agro/models/control.dart';
import 'package:c3_ppl_agro/services/control_service.dart';
import 'package:c3_ppl_agro/services/mqtt_service.dart';
import 'package:flutter/foundation.dart';

class ControlViewModel with ChangeNotifier {
  final ControlService _controlService = ControlService();
  final MqttService _mqttService = MqttService();

  List<Control> _controls = [];
  List<Control> get controls => _controls;

  ControlViewModel() {
    _init();
  }

  Future<void> _init() async {
    await getAllControls();
    _listenToRealtimeControlChanges();
    _listenToMqttControlStatus();
  }

  Future<void> getAllControls() async {
    _controls = await _controlService.fetchAllControls();
    notifyListeners();
  }

  Control getControlById(int id) {
    return _controls.firstWhere(
      (control) => control.id == id,
      orElse: () => Control(
        id: id,
        status: 'OFF',
      ),
    );
  }

  void _listenToRealtimeControlChanges() {
    _controlService.listenToAllControlChanges((updated) {
      final index = _controls.indexWhere((c) => c.id == updated.id);
      if (index != -1) {
        _controls[index] = updated;
        notifyListeners();
      }
    });
  }


  void _listenToMqttControlStatus() async {
    await _mqttService.connect(
      onSensorMessage: (_) {},
      onControlStatusChanged: (statusData) async {
        final int controlId = statusData['id'] ?? 1;
        final String newStatus = statusData['status'] ?? 'OFF';

        try {
          await _controlService.insertNewControlStatus(controlId, newStatus);

          final index = _controls.indexWhere((c) => c.id == controlId);
          if (index != -1) {
            _controls[index] = _controls[index].copyWith(status: newStatus);
            notifyListeners();
          }
          debugPrint('Status kontrol diperbarui dari MQTT: $controlId => $newStatus');
        } catch (e) {
          debugPrint('Gagal update status dari MQTT: $e');
        }
      },
    );
  }
}
