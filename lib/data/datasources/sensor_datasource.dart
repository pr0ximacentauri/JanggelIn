import "package:c3_ppl_agro/config/supabase_client.dart";
import "package:supabase/supabase.dart";
import "../../domain/models/sensor_model.dart";


abstract class SensorDataSource{
  Future<List<SensorModel>> fetchSensorData();
  Future<void> insertSensorData(SensorModel data);
}

class SensorDataSourceImpl implements SensorDataSource {
  final SupabaseClient client = SupabaseClientConfig.client;

  @override
  Future<List<SensorModel>> fetchSensorData() async{
    final response = await client.from('sensor_data').select();
    return response.map((json) => SensorModel.fromJson(json)).toList();
  }

  @override
  Future<void> insertSensorData(SensorModel data) async{
    await client.from('sensor_data').insert(data.toJson());
  }
}