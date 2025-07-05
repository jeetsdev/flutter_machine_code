import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:test_app/core/config/api_config.dart';
import 'package:test_app/core/network/dio_client.dart';
import 'package:test_app/parking_lot/data/remote/parking_remote_source.dart';

final sl = GetIt.instance;

@injectableInit
void configureDependencies() {
  // sl.init();
  sl.registerLazySingleton<DioClient>(() => DioClient.initialize(
        baseUrl: ApiConfig.baseUrl,
      ));
  sl.registerFactory<ParkingRemoteSource>(
      () => ParkingRemoteSource(sl<DioClient>()));
}
