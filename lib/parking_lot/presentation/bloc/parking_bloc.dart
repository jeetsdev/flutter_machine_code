// Presentation Layer: BLoC

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/strategies/pricing_strategies.dart';
import '../../domain/usecases/parking_usecases.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkVehicleUseCase parkVehicleUseCase;
  final UnparkVehicleUseCase unparkVehicleUseCase;
  final GetAllSlotsUseCase getAllSlotsUseCase;
  final GetActiveTicketsUseCase getActiveTicketsUseCase;

  Timer? _autoRefreshTimer;

  ParkingBloc({
    required this.parkVehicleUseCase,
    required this.unparkVehicleUseCase,
    required this.getAllSlotsUseCase,
    required this.getActiveTicketsUseCase,
  }) : super(const ParkingInitial()) {
    on<LoadParkingSlots>(_onLoadParkingSlots);
    on<ParkVehicle>(_onParkVehicle);
    on<UnparkVehicle>(_onUnparkVehicle);
    on<SelectPricingType>(_onSelectPricingType);
    on<RefreshSlots>(_onRefreshSlots);
    on<LoadActiveTickets>(_onLoadActiveTickets);

    // Start auto-refresh timer
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      add(RefreshSlots());
    });
  }

  Future<void> _onLoadParkingSlots(
    LoadParkingSlots event,
    Emitter<ParkingState> emit,
  ) async {
    emit(const ParkingLoading());
    try {
      final slots = await getAllSlotsUseCase.execute();
      final activeTickets = await getActiveTicketsUseCase.execute();
      final trafficLevel =
          slots.where((s) => s.isOccupied).length / slots.length;

      emit(ParkingLoaded(
        slots: slots,
        activeTickets: activeTickets,
        selectedPricingType: event.pricingType ?? 'hourly',
        trafficLevel: trafficLevel,
      ));
    } catch (e) {
      emit(ParkingError('Failed to load data: $e'));
    }
  }

  Future<void> _onParkVehicle(
    ParkVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      final ticket =
          await parkVehicleUseCase.execute(event.slotId, event.vehicle);
      emit(VehicleParked(
        ticket,
        'Vehicle ${event.vehicle.licensePlate} parked successfully in slot ${ticket.slotId}',
      ));

      // Reload data after parking
      add(LoadParkingSlots());
    } catch (e) {
      emit(ParkingError('Failed to park vehicle: $e'));
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

      final pricingStrategy = PricingCalculator.getPricingStrategy(
        type: event.pricingType,
        trafficLevel: 0.5, // Default value for display
      );

      emit(VehicleUnparked(
        price,
        pricingStrategy.strategyName,
        'Vehicle unparked. Total cost: \$${price.toStringAsFixed(2)}',
      ));

      // Reload data after unparking
      add(LoadParkingSlots());
    } catch (e) {
      emit(ParkingError('Failed to unpark vehicle: $e'));
    }
  }

  Future<void> _onSelectPricingType(
    SelectPricingType event,
    Emitter<ParkingState> emit,
  ) async {
    if (state is ParkingLoaded) {
      final currentState = state as ParkingLoaded;
      emit(currentState.copyWith(
        selectedPricingType: event.pricingType,
        message: 'Pricing type changed to ${event.pricingType}',
      ));
    }
  }

  Future<void> _onRefreshSlots(
    RefreshSlots event,
    Emitter<ParkingState> emit,
  ) async {
    if (state is ParkingLoaded) {
      final currentState = state as ParkingLoaded;
      try {
        final slots = await getAllSlotsUseCase.execute();
        final activeTickets = await getActiveTicketsUseCase.execute();
        emit(currentState.copyWith(
          slots: slots,
          activeTickets: activeTickets,
          trafficLevel: slots.where((s) => s.isOccupied).length / slots.length,
        ));
      } catch (e) {
        emit(ParkingError('Failed to refresh slots: $e'));
      }
    }
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
        emit(ParkingError('Failed to load active tickets: $e'));
      }
    }
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }
}
