import 'package:supabase_flutter/supabase_flutter.dart';
import '../sensor_data.dart';

class SensorService {
  final _supabase = Supabase.instance.client;

  Future<SensorData?> fetchLatestSensorData() async {
    final response = await _supabase
        .from('sensor_data')
        .select()
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return SensorData.fromJson(response);
  }
}