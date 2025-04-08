import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/datasources/remote/supabase_service.dart';
import 'data/repositories/database_repository_impl.dart';
import 'domain/repositories/database_repository.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey:  dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  final supabase = Supabase.instance.client;
  locator.registerSingleton<SupabaseClient>(supabase);

  final dio = Dio();
  locator.registerSingleton<Dio>(dio);

  locator.registerSingleton<SupabaseService>(
    SupabaseService(locator<SupabaseClient>()),
  );

  locator.registerSingleton<DatabaseRepository>(
    DatabaseRepositoryImpl(locator<SupabaseService>()),
  );
}
