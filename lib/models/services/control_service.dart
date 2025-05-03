import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../control.dart';

class ControlService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Control>> fetchAllControls() async {
    final response = await _client
        .from('kontrol')
        .select();

    if (response == null) return [];
    return (response as List).map((json) => Control.fromJson(json)).toList();
  }
  
//  Future<Control?> updateControlStatusById(int id, String newStatus) async {
//     final response = await _client
//         .from('kontrol')
//         .update({'status': newStatus})
//         .eq('id_kontrol', id)
//         .select()
//         .maybeSingle();

//     if (response == null) return null;
//     return Control.fromJson(response);
//   }

  Future<SensorData?> updatePumpStatusById(String newStatus) async {
    final response = await _client
        .from('sensor_data')
        .update({'status_pompa': newStatus})
        .select()
        .maybeSingle();

    if (response == null) return null;
    return SensorData.fromJson(response);
  }
  Future<SensorData?> updateFanStatusById(String newStatus) async {
    final response = await _client
        .from('sensor_data')
        .update({'status_kipas': newStatus})
        .select()
        .maybeSingle();

    if (response == null) return null;
    return SensorData.fromJson(response);
  }
  Future<SensorData?> updateLamptatusById(String newStatus) async {
    final response = await _client
        .from('sensor_data')
        .update({'status_lampu': newStatus})
        .select()
        .maybeSingle();

    if (response == null) return null;
    return SensorData.fromJson(response);
  }

  void listenToAllControlChanges(Function(Control updated) onChange) {
    _client.channel('public:kontrol')
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'kontrol',
        callback: (payload) {
          final control = Control.fromJson(payload.newRecord);
          onChange(control);
        },
      ).subscribe();
  }
}
