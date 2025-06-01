import 'package:c3_ppl_agro/models/control.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControlService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Control>> fetchAllControls() async {
    final response = await _client
        .from('kontrol')
        .select('id_kontrol, status, fk_perangkat, perangkat(id_perangkat, nama)');

    if (response == null) return [];

    return (response as List).map((json) => Control.fromJson(json)).toList();
  }

  /// Mengubah status kontrol berdasarkan ID kontrol
  Future<Control?> updateControlStatusById(int id, String newStatus) async {
    final response = await _client
        .from('kontrol')
        .update({'status': newStatus})
        .eq('id', id)
        .select('id, status, perangkat_id, perangkat(id, nama)')
        .maybeSingle();

    if (response == null) return null;
    return Control.fromJson(response);
  }

  /// Mendengarkan perubahan data kontrol
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
