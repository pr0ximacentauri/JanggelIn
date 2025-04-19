import 'package:supabase_flutter/supabase_flutter.dart';
import '../control.dart';

class ControlService {
  final _supabase = Supabase.instance.client;

  Future<Control?> fetchControl() async {
    final response = await _supabase
        .from('kontrol')
        .select()
        .eq('id_kontrol', 1)
        .maybeSingle();

    if (response == null) return null;
    return Control.fromJson(response);
  }

  Future<Control?> updateControlStatus(String newStatus) async {
    final response = await _supabase
        .from('kontrol')
        .update({'status': newStatus})
        .eq('id_kontrol', 1)
        .select()
        .maybeSingle();

    if (response == null) return null;
    return Control.fromJson(response);
  }
}
