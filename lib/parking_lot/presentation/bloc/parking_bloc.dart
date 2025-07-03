// Presentation Layer: BLoC

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/parking_usecases.dart';
import '../../domain/strategies/pricing_strategies.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkVehicleUseCase parkVehicleUseCase;
  final UnparkVehicleUseCase unparkVehicleUseCase;
  final GetAllSlotsUseCase getAllSlotsUseCase;
  final GetActiveTicketsUseCase getActiveTicketsUseCase;

  StreamSubscription? _slotsSubscription;

  ParkingBloc({
    required this.parkVehicleUseCase,
    required this.unparkVehicleUseCase,
    required this.getAllSlotsUseCase,
    required this.getActiveTicketsUseCase,
  }) : super(ParkingInitial()) {
    on<LoadParkingSlots>(_onLoadParkingSlots);
    on<ParkVehicle>(_onParkVehicle);
    on<UnparkVehicle>(_onUnparkVehicle);
    on<SelectPricingType>(_onSelectPricingType);
    on<RefreshSlots>(_onRefreshSlots);
    on<LoadActiveTickets>(_onLoadActiveTickets);
  }


  Future<void> _onLoadParkingSlots(
    LoadParkingSlots event,
    Emitter<ParkingState> emit,
  ) async {
    emit(ParkingLoading());
    try {
      final slots = await getAllSlotsUseCase.execute();
      final activeTickets = await getActiveTicketsUseCase.execute();

      emit(ParkingLoaded(
        slots: slots,
        activeTickets: activeTickets,
        selectedPricingType: 'hourly',
        trafficLevel: slots.where((s) => s.isOccupied).length / slots.length,
      ));
    } catch (e) {
      emit(ParkingError(e.toString()));
    }
  }

  Future<void> _onParkVehicle(
    ParkVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      final ticket = await parkVehicleUseCase.execute(event.slotId);
      emit(VehicleParked(ticket));

      // Reload data after parking
      add(LoadParkingSlots());
    } catch (e) {
      emit(ParkingError(e.toString()));
    }
  }

  Future<void> _onUnparkVehicle(
    UnparkVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      final price = await unparkVehicleUseCase.execute(
        event.ticket,
        event.pricingType,
      );

      // Get pricing strategy name for display
      final pricingStrategy = PricingCalculator.getPricingStrategy(
        type: event.pricingType,
        trafficLevel: 0.5, // Default value for display
      );

      emit(VehicleUnparked(price, pricingStrategy.strategyName));

      // Reload data after unparking
      add(LoadParkingSlots());
    } catch (e) {
      emit(ParkingError(e.toString()));
    }
  }

  Future<void> _onSelectPricingType(
    SelectPricingType event,
    Emitter<ParkingState> emit,
  ) async {
    if (state is ParkingLoaded) {
      final currentState = state as ParkingLoaded;
      emit(currentState.copyWith(selectedPricingType: event.pricingType));
    }
  }

  Future<void> _onRefreshSlots(
    RefreshSlots event,
    Emitter<ParkingState> emit,
  ) async {
    add(LoadParkingSlots());
  }

  Future<void> _onLoadActiveTickets(
    LoadActiveTickets event,
    Emitter<ParkingState> emit,
  ) async {
    if (state is ParkingLoaded) {
      try {
        final activeTickets = await getActiveTicketsUseCase.execute();
        final currentState = state as ParkingLoaded;
        emit(currentState.copyWith(activeTickets: activeTickets));
      } catch (e) {
        emit(ParkingError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _slotsSubscription?.cancel();
    return super.close();
  }
}
