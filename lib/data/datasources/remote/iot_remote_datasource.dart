// tabel sementara

import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class IoTRemoteDataSource {
  final SupabaseClient _client = SupabaseClientService.client;

  Future<Map<String, dynamic>?> getLatestSensorData() async {
    final response = await _client.from('sensor_data').select().order('timestamp', ascending: false).limit(1);
    return response.isNotEmpty ? response.first : null;
  }

  Future<void> updateDeviceSettings(Map<String, dynamic> newSettings) async {
    await _client.from('device_settings').upsert(newSettings);
  }
}
