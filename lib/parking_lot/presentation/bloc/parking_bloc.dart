// Presentation Layer: BLoC

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/parking_lot/domain/usecases/get_active_tickets_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/get_all_slots_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/park_vehicle_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/unpark_vehicle_use_case.dart';

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
  }) : super(const ParkingState()) {
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
    emit(state.loading());
    try {
      final activeTickets = await getActiveTicketsUseCase.execute();

      if (state.slots.isEmpty) {
        final slots = await getAllSlotsUseCase.execute();
        emit(state.success(slots: slots, activeTickets: activeTickets));
      } else {
        final updatedSlots = state.slots.map((slot) {
          if (slot.id == event.slotId) {
            return slot.copyWith(isOccupied: true);
          }
          return slot;
        }).toList();
        emit(state.success(
          slots: updatedSlots,
        ));
      }
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> _onParkVehicle(
    ParkVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      emit(state.loading());
      final ticket = await parkVehicleUseCase.execute(event.slotId);

      // First update the parking state
      final updatedState = state.parkVehicle(ticket);
      emit(updatedState.success());

      // Optionally refresh all data
      add(LoadParkingSlots(slotId: event.slotId));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> _onUnparkVehicle(
    UnparkVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      emit(state.loading());
      final price = await unparkVehicleUseCase.execute(
        event.ticket,
        event.pricingType,
      );

      // Get pricing strategy name for display
      final pricingStrategy = PricingCalculator.getPricingStrategy(
        type: event.pricingType,
        trafficLevel: state.trafficLevel,
      );

      // First update the unparking state
      final updatedState = state.unparkVehicle(
        event.ticket.slotId,
        price,
        pricingStrategy.strategyName,
      );
      emit(updatedState.success());

      // Optionally refresh all data
      add(LoadParkingSlots());
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> _onSelectPricingType(
    SelectPricingType event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      emit(state.success(selectedPricingType: event.pricingType));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> _onRefreshSlots(
    RefreshSlots event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      emit(state.loading());
      final slots = await getAllSlotsUseCase.execute();
      emit(state.success(slots: slots));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> _onLoadActiveTickets(
    LoadActiveTickets event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      emit(state.loading());
      final activeTickets = await getActiveTicketsUseCase.execute();
      emit(state.success(activeTickets: activeTickets));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _slotsSubscription?.cancel();
    return super.close();
  }
}
