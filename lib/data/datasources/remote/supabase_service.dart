import 'package:c3_ppl_agro/domain/models/device_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:c3_ppl_agro/domain/models/sensor.dart';

class SupabaseService {
  final SupabaseClient supabase;

  SupabaseService(this.supabase);

  Future<Sensor?> fetchLatestSensorData() async {
    final response = await supabase
        .from("sensor") // tabel sementara
        .select()
        .order("timestamp", ascending: false)
        .limit(1)
        .single();

    return Sensor.fromJson(response);
  }

  Future<DeviceStatus?> getDeviceStatus() async {
    final response = await supabase
        .from("device_status") // tabel sementara
        .select()
        .order("id", ascending: false)
        .limit(1)
        .single();

    // if (response == null) return null;
    return DeviceStatus.fromJson(response);
  }

  Future<void> updateDeviceStatus(bool isOn) async {
    await supabase.from("device_status").upsert({
      'id': 1,
      'status': isOn ? 1 : 0,
    });
  }
}