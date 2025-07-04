import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/entry_gate.dart';
import '../../domain/entities/parking_lot.dart';
import '../../domain/entities/parking_slot.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_size.dart';
import '../../domain/usecases/get_parking_lot_status_usecase.dart';
import '../../domain/usecases/park_vehicle_usecase.dart';
import '../../domain/usecases/unpark_vehicle_usecase.dart';

// Events
abstract class ParkingLotEvent extends Equatable {
  const ParkingLotEvent();

  @override
  List<Object?> get props => [];
}

class LoadParkingLotStatus extends ParkingLotEvent {}

class ParkNewVehicle extends ParkingLotEvent {
  final String licensePlate;
  final VehicleSize vehicleSize;
  final String entryGateId;

  const ParkNewVehicle({
    required this.licensePlate,
    required this.vehicleSize,
    required this.entryGateId,
  });

  @override
  List<Object?> get props => [licensePlate, vehicleSize, entryGateId];
}

class UnparkVehicle extends ParkingLotEvent {
  final String vehicleId;

  const UnparkVehicle(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}

// States
abstract class ParkingLotState extends Equatable {
  const ParkingLotState();

  @override
  List<Object?> get props => [];
}

class ParkingLotInitial extends ParkingLotState {}

class ParkingLotLoading extends ParkingLotState {}

class ParkingLotLoaded extends ParkingLotState {
  final ParkingLot parkingLot;
  final Map<String, dynamic> status;

  const ParkingLotLoaded({
    required this.parkingLot,
    required this.status,
  });

  @override
  List<Object?> get props => [parkingLot, status];
}

class ParkingLotError extends ParkingLotState {
  final String message;

  const ParkingLotError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleParked extends ParkingLotState {
  final String message;
  final ParkingSlot slot;

  const VehicleParked({
    required this.message,
    required this.slot,
  });

  @override
  List<Object?> get props => [message, slot];
}

class VehicleUnparked extends ParkingLotState {
  final String message;
  final Vehicle vehicle;

  const VehicleUnparked({
    required this.message,
    required this.vehicle,
  });

  @override
  List<Object?> get props => [message, vehicle];
}

// Bloc
class ParkingLotBloc extends Bloc<ParkingLotEvent, ParkingLotState> {
  final GetParkingLotStatusUseCase getParkingLotStatus;
  final ParkVehicleUseCase parkVehicle;
  final UnparkVehicleUseCase unparkVehicle;

  ParkingLotBloc({
    required this.getParkingLotStatus,
    required this.parkVehicle,
    required this.unparkVehicle,
  }) : super(ParkingLotInitial()) {
    on<LoadParkingLotStatus>(_onLoadParkingLotStatus);
    on<ParkNewVehicle>(_onParkNewVehicle);
    on<UnparkVehicle>(_onUnparkVehicle);
  }

  Future<void> _onLoadParkingLotStatus(
    LoadParkingLotStatus event,
    Emitter<ParkingLotState> emit,
  ) async {
    emit(ParkingLotLoading());

    try {
      final result = await getParkingLotStatus();

      if (result.isSuccess &&
          result.parkingLot != null &&
          result.status != null) {
        emit(ParkingLotLoaded(
          parkingLot: result.parkingLot!,
          status: result.status!,
        ));
      } else {
        emit(ParkingLotError(result.errorMessage ?? 'Unknown error'));
      }
    } catch (e) {
      emit(ParkingLotError(e.toString()));
    }
  }

  Future<void> _onParkNewVehicle(
    ParkNewVehicle event,
    Emitter<ParkingLotState> emit,
  ) async {
    emit(ParkingLotLoading());

    try {
      final vehicle = VehicleFactory.createVehicle(
        size: event.vehicleSize,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        licensePlate: event.licensePlate,
      );

      final result = await parkVehicle(ParkVehicleParams(
        vehicle: vehicle,
        entryGateId: event.entryGateId,
      ));

      if (result.isSuccess && result.slot != null) {
        emit(VehicleParked(
          message: result.message,
          slot: result.slot!,
        ));
      } else {
        emit(ParkingLotError(result.message));
      }

      // Reload parking lot status
      add(LoadParkingLotStatus());
    } catch (e) {
      emit(ParkingLotError(e.toString()));
    }
  }

  Future<void> _onUnparkVehicle(
    UnparkVehicle event,
    Emitter<ParkingLotState> emit,
  ) async {
    emit(ParkingLotLoading());

    try {
      final result = await unparkVehicle(event.vehicleId);

      if (result.isSuccess && result.vehicle != null) {
        emit(VehicleUnparked(
          message: result.message,
          vehicle: result.vehicle!,
        ));
      } else {
        emit(ParkingLotError(result.message));
      }

      // Reload parking lot status
      add(LoadParkingLotStatus());
    } catch (e) {
      emit(ParkingLotError(e.toString()));
    }
  }
}
