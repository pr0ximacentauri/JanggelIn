// tabel sementara

import 'package:hive/hive.dart';

class DeviceStateCache {
  static Future<void> saveLastSensorData(Map<String, dynamic> sensorData) async {
    final box = await Hive.openBox('device_state');
    await box.put('last_sensor_data', sensorData);
  }

  static Future<Map<String, dynamic>?> getLastSensorData() async {
    final box = await Hive.openBox('device_state');
    return box.get('last_sensor_data');
  }
}
