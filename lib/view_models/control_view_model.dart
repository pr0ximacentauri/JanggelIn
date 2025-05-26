import 'dart:async';
import 'package:c3_ppl_agro/models/control.dart';
import 'package:c3_ppl_agro/models/services/control_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControlViewModel with ChangeNotifier {
  final ControlService _controlService = ControlService();
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Control> _controls = [];
  List<Control> get controls => _controls;

  ControlViewModel() {
    _init();
  }

  Future<void> _init() async {
    await getAllControls();    
    _subscribeToRealtimeChanges();  
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
        name: 'Unknown',
        status: 'OFF',
        updatedAt: DateTime.now(),
      ),
    );
  }

  void _subscribeToRealtimeChanges() {
    final channel = _supabase.channel('public:kontrol');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'kontrol',
          callback: (payload) {
            final updated = Control.fromJson(payload.newRecord);
            final index = _controls.indexWhere((c) => c.id == updated.id);
            if (index != -1) {
              _controls[index] = updated;
              notifyListeners();
            }
          },
        )
        .subscribe();
  }
}
