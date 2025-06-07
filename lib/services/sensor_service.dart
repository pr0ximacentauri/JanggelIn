import 'package:c3_ppl_agro/models/sensor_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SensorService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<SensorData?> fetchLatestSensorData() async {
    final response = await _client
        .from('sensor_data')
        .select()
        .order('updated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return SensorData.fromJson(response);
  }

  Future<List<SensorData>> fetchAllSensorData() async {
    final response = await _client
        .from('sensor_data')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => SensorData.fromJson(json))
        .toList();
  }


  void listenToSensorUpdates(Function(SensorData data) onData) {
    _client.channel('public:sensor_data')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'sensor_data',
        callback: (payload) {
          final data = SensorData.fromJson(payload.newRecord);
          onData(data);
        },
      ).subscribe();
  }

  Future<void> uploadSensorData(SensorData data) async {
    await _client.from('sensor_data').insert({
      'suhu': data.temperature,
      'kelembapan': data.humidity,
      'created_at': data.createdAt.toIso8601String(),
      'updated_at': data.updatedAt.toIso8601String(),
      'fk_batas': data.fkOptimalLimit
    });
  }

}