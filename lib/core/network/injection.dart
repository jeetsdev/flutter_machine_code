import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:test_app/core/network/injection.config.dart';

final sl = GetIt.instance;

@injectableInit
void configureDependencies() {
  sl.init();
  // sl.registerLazySingleton<DioClient>(() => DioClient.initialize(
  //       baseUrl: ApiConfig.baseUrl,
  //     ));
  // sl.registerFactory<ParkingRemoteSource>(
  //     () => ParkingRemoteSource(sl<DioClient>()));
}
