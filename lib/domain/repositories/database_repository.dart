import 'package:c3_ppl_agro/domain/models/device_status.dart';
import 'package:c3_ppl_agro/domain/models/sensor.dart';

abstract class DatabaseRepository {
  Future<Sensor?> fetchLatestSensorData();
  Future<DeviceStatus?> getDeviceStatus();
  Future<void> updateDeviceStatus(bool isOn);
}