import 'package:supabase_flutter/supabase_flutter.dart';
import '../optimal_limit.dart';

class OptimalLimitService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<OptimalLimit?> fetchOptimalLimit() async {
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

  Future<List<OptimalLimit>> fetchAllOptimalLimits() async {
    final response = await _client
        .from('batas_optimal')
        .select()
        .order('updated_at', ascending: true);

    if (response != null) {
      return (response as List)
          .map((json) => OptimalLimit.fromJson(json))
          .toList();
    }
    return [];
  }

   Future<void> insertOptimalLimit({
    required double minTemperature,
    required double maxTemperature,
    required double minHumidity,
    required double maxHumidity,
  }) async {
    await _client
        .from('batas_optimal')
        .select('id_batas')
        .limit(1)
        .maybeSingle();
    await _client.from('batas_optimal').insert({
      'min_suhu': minTemperature,
      'maks_suhu': maxTemperature,
      'min_kelembapan': minHumidity,
      'maks_kelembapan': maxHumidity,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
