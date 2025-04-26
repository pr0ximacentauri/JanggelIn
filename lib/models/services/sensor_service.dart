import 'package:supabase_flutter/supabase_flutter.dart';
import '../sensor_data.dart';

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
        .order('created_at', ascending: true);

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
}