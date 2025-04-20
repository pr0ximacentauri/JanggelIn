import 'package:supabase_flutter/supabase_flutter.dart';
import '../optimal_limit.dart';

class OptimalLimitService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<OptimalLimit?> fetchLatestLimit() async {
    final response = await _client
        .from('batas_optimal')
        .select()
        .order('updated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response != null) {
      return OptimalLimit.fromJson(response);
    }
    return null;
  }
}
