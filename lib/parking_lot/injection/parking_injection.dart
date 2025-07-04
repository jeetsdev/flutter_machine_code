// Dependency Injection Setup

import '../data/repositories/parking_repository_impl.dart';
import '../domain/repositories/parking_repository.dart';
import '../domain/usecases/parking_usecases.dart';
import '../presentation/bloc/parking_bloc.dart';

class ParkingDependencyInjection {
  static ParkingRepository? _parkingRepository;

  static ParkingRepository _getRepository() {
    return _parkingRepository ??= ParkingRepositoryImpl();
  }

  static ParkingBloc getParkingBloc() {
    final repository = _getRepository();

    return ParkingBloc(
      parkVehicleUseCase: ParkVehicleUseCase(repository),
      unparkVehicleUseCase: UnparkVehicleUseCase(repository),
      getAllSlotsUseCase: GetAllSlotsUseCase(repository),
      getActiveTicketsUseCase: GetActiveTicketsUseCase(repository),
    );
  }

  static void dispose() {
    _parkingRepository = null;
  }
}
