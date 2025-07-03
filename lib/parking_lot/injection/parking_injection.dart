// Dependency Injection Setup

import '../data/repositories/parking_repository_impl.dart';
import '../domain/repositories/parking_repository.dart';
import '../domain/usecases/parking_usecases.dart';
import '../presentation/bloc/parking_bloc.dart';
import '../presentation/controllers/parking_controller.dart';

class ParkingDependencyInjection {
  static ParkingController? _parkingController;
  static ParkingRepository? _parkingRepository;

  static ParkingRepository _getRepository() {
    return _parkingRepository ??= ParkingRepositoryImpl();
  }

  static ParkingController getParkingController() {
    final repository = _getRepository();

    _parkingController ??= ParkingController(
      parkVehicleUseCase: ParkVehicleUseCase(repository),
      unparkVehicleUseCase: UnparkVehicleUseCase(repository),
      getAllSlotsUseCase: GetAllSlotsUseCase(repository),
      getActiveTicketsUseCase: GetActiveTicketsUseCase(repository),
    );

    return _parkingController!;
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
    _parkingController?.dispose();
    // Repository disposal removed as it no longer has a dispose method
    _parkingController = null;
    _parkingRepository = null;
  }
}
