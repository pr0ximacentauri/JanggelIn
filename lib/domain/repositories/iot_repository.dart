import 'package:c3_ppl_agro/domain/models/device_settings.dart';
import 'package:c3_ppl_agro/domain/models/sensor_data.dart';

abstract class IoTRepository {
  Future<SensorData?> fetchLatestSensorData();
  Future<void> updateDeviceSettings(DeviceSettings settings);
}
