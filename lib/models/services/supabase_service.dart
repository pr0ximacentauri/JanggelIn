import 'package:c3_ppl_agro/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../sensor_data.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseClient(AppConfig.supabaseUrl, AppConfig.supabaseAnonKey);

  Future<void> updateDeviceStatus(String deviceId, bool status) async {
    await _client.from('devices').upsert({'id': deviceId, 'status': status});
  }

  Future<SensorData?> getDeviceStatus(String deviceId) async {
    final response = await _client.from('devices').select().eq('id', deviceId).single();
    if (response != null) {
      return SensorData.fromJson(response);
    }
    return null;
  }
}
