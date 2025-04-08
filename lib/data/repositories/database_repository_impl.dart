import 'package:c3_ppl_agro/data/datasources/remote/supabase_service.dart';
import 'package:c3_ppl_agro/domain/models/device_status.dart';
import 'package:c3_ppl_agro/domain/models/sensor.dart';
import 'package:c3_ppl_agro/domain/repositories/database_repository.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final SupabaseService _supabaseService;

  DatabaseRepositoryImpl(this._supabaseService);

  @override
  Future<Sensor?> fetchLatestSensorData() {
    return _supabaseService.fetchLatestSensorData();
  }

  @override
  Future<DeviceStatus?> getDeviceStatus() {
    return _supabaseService.getDeviceStatus();
  }

  @override
  Future<void> updateDeviceStatus(bool isOn) {
    return _supabaseService.updateDeviceStatus(isOn);
  }
}