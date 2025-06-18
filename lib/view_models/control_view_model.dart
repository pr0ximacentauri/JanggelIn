import 'package:JanggelIn/models/control.dart';
import 'package:JanggelIn/services/control_service.dart';
import 'package:JanggelIn/services/mqtt_service.dart';
import 'package:flutter/foundation.dart';

class ControlViewModel with ChangeNotifier {
  final ControlService _controlService = ControlService();
  final MqttService _mqttService = MqttService();

  List<Control> _controls = [];
  List<Control> get controls => _controls;
  final Map<int, String> _lastStatusPerDevice = {};
  ControlViewModel() {
    init();
  }

  Future<void> init() async {
    await getAllControls();
    _listenToRealtimeControlChanges();
    _listenToMqttControlStatus();
  }

  Future<void> getAllControls() async {
    _controls = await _controlService.fetchAllControls();
    notifyListeners();
  }

  Future<Control> getControlByDeviceId(int deviceId) async{
    return await _controlService.getLatestControlByDeviceId(deviceId);
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
      onControlStatusChanged: (List<Map<String, dynamic>> statusList) async {
        for (final statusData in statusList) {
          final String newStatus = statusData['status'] ?? 'OFF';
          final int deviceId = statusData['deviceId'] ?? 1;

          final String? lastStatus = _lastStatusPerDevice[deviceId];

          if (lastStatus != newStatus) {
            try {
              await _controlService.uploadControlStatusByDeviceId(newStatus, deviceId);

              _lastStatusPerDevice[deviceId] = newStatus;

              final index = _controls.indexWhere((c) => c.id == deviceId);
              if (index != -1) {
                _controls[index] = _controls[index].copyWith(status: newStatus);
                notifyListeners();
              }

              debugPrint('Status kontrol diperbarui dari MQTT: $deviceId => $newStatus');
            } catch (e) {
              debugPrint('Gagal update status dari MQTT: $e');
            }
          }
        }
      },
    );
  }

}
