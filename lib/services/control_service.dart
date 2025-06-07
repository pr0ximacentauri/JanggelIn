import 'package:c3_ppl_agro/models/control.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControlService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Control>> fetchAllControls() async {
    final response = await _client
        .from('kontrol')
        .select('id_kontrol, status, fk_perangkat, perangkat(id_perangkat, nama)')
        .order('updated_at', ascending: false);

    // ignore: unnecessary_null_comparison
    if (response == null) return [];

    return (response as List).map((json) => Control.fromJson(json)).toList();
  }

  Future<void> uploadControlStatusByDeviceId(String status, int deviceId) async {
    await _client.from('kontrol').insert({
      'status': status,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'fk_perangkat': deviceId,
    });
  }

  Future<Control> getLatestControlByDeviceId(int deviceId) async{
    final response = await _client
      .from('kontrol')
      .select('*, perangkat(*)')
      .eq('fk_perangkat', deviceId)
      .order('updated_at', ascending: false)
      .limit(1)
      .maybeSingle();

    if (response == null) return Control(id: 0, status: 'OFF', deviceId: deviceId);

    return Control.fromJson(response);
  }
  
  void listenToAllControlChanges(Function(Control updated) onChange) {
    _client.channel('public:kontrol')
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'kontrol',
        callback: (payload) {
          final updated = Control.fromJson(payload.newRecord);
          onChange(updated);
        },
      )
      .subscribe();
  }
}
