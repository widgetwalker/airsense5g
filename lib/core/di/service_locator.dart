import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:air_quality_guardian/core/network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => DioClient());

  // TODO: Register data sources

  // TODO: Register repositories

  // TODO: Register use cases

  // TODO: Register providers
}
