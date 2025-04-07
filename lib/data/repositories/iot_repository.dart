import 'package:c3_ppl_agro/data/datasources/local/device_state_cache.dart';
import 'package:c3_ppl_agro/data/datasources/remote/iot_remote_datasource.dart';

class IotRepository {
  final IoTRemoteDataSource _iotRemoteDataSource;

  IotRepository(this._iotRemoteDataSource);

  Future<Map<String, dynamic>?> fetchLatestSensorData() async{
    try{
      final data = await _iotRemoteDataSource.getLatestSensorData();
      if (data != null){
        await DeviceStateCache.saveLastSensorData(data);
        return data;
      }
    }catch(e){
      return await DeviceStateCache.getLastSensorData(); // Fallback ke data cache
    }
    return null;
  }
}