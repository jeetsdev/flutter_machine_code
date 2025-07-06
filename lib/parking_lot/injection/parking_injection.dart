// Dependency Injection Setup

import 'package:test_app/parking_lot/domain/usecases/get_active_tickets_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/get_all_slots_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/park_vehicle_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/unpark_vehicle_use_case.dart';

import '../data/repositories/parking_repository_impl.dart';
import '../domain/repositories/parking_repository.dart';
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
