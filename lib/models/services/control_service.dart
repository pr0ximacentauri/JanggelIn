import 'package:supabase_flutter/supabase_flutter.dart';
import '../control.dart';

class ControlService {
  final _supabase = Supabase.instance.client;

  Future<List<Control>> fetchAllControls() async {
    final response = await _supabase
        .from('kontrol')
        .select();

    if (response == null) return [];
    return (response as List).map((json) => Control.fromJson(json)).toList();
  }

  Future<Control?> fetchControlById(int id) async {
    final response = await _supabase
        .from('kontrol')
        .select()
        .eq('id_kontrol', id)
        .maybeSingle();

    if (response == null) return null;
    return Control.fromJson(response);
  }

 Future<Control?> updateControlStatusById(int id, String newStatus) async {
    final response = await _supabase
        .from('kontrol')
        .update({'status': newStatus})
        .eq('id_kontrol', id)
        .select()
        .maybeSingle();

    if (response == null) return null;
    return Control.fromJson(response);
  }
}
