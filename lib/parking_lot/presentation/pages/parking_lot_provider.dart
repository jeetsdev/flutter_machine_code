import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/parking_lot/data/datasources/parking_remote_datasource.dart';
import '../../data/repositories/parking_repository_impl.dart';
import '../../domain/usecases/get_parking_lot_status_usecase.dart';
import '../../domain/usecases/park_vehicle_usecase.dart';
import '../../domain/usecases/unpark_vehicle_usecase.dart';
import '../bloc/parking_lot_bloc.dart';
import 'parking_lot_screen.dart';

class ParkingLotProvider extends StatelessWidget {
  const ParkingLotProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final remoteDataSource = ParkingRemoteDataSource();
        final repository = ParkingRepositoryImpl(remoteDataSource: remoteDataSource);

        return ParkingLotBloc(
          getParkingLotStatus: GetParkingLotStatusUseCase(repository),
          parkVehicle: ParkVehicleUseCase(repository),
          unparkVehicle: UnparkVehicleUseCase(repository),
        )..add(LoadParkingLotStatus());
      },
      child: const ParkingLotScreen(),
    );
  }
}
