// Presentation Layer: BLoC States

import '../../domain/entities/parking_entities.dart';

enum ApiStatus {
  initial,
  loading,
  success,
  error,
}

class ParkingState {
  final ApiStatus status;
  final String? errorMessage;
  final List<ParkingSlot> slots;
  final List<ParkingTicket> activeTickets;
  final String selectedPricingType;
  final double trafficLevel;
  final ParkingTicket? lastParkedTicket;
  final UnparkResult? lastUnparkResult;

  const ParkingState({
    this.status = ApiStatus.initial,
    this.errorMessage,
    this.slots = const [],
    this.activeTickets = const [],
    this.selectedPricingType = 'hourly',
    this.trafficLevel = 0.0,
    this.lastParkedTicket,
    this.lastUnparkResult,
  });

  bool get isInitial => status == ApiStatus.initial;
  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;

  ParkingState copyWith({
    ApiStatus? status,
    String? Function()? errorMessage,
    List<ParkingSlot>? slots,
    List<ParkingTicket>? activeTickets,
    String? selectedPricingType,
    double? trafficLevel,
    ParkingTicket? Function()? lastParkedTicket,
    UnparkResult? Function()? lastUnparkResult,
  }) {
    return ParkingState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      slots: slots ?? this.slots,
      activeTickets: activeTickets ?? this.activeTickets,
      selectedPricingType: selectedPricingType ?? this.selectedPricingType,
      trafficLevel: trafficLevel ?? this.trafficLevel,
      lastParkedTicket:
          lastParkedTicket != null ? lastParkedTicket() : this.lastParkedTicket,
      lastUnparkResult:
          lastUnparkResult != null ? lastUnparkResult() : this.lastUnparkResult,
    );
  }

  ParkingState loading() => copyWith(status: ApiStatus.loading);

  ParkingState error(String message) => copyWith(
        status: ApiStatus.error,
        errorMessage: () => message,
      );

  ParkingState success({
    List<ParkingSlot>? slots,
    List<ParkingTicket>? activeTickets,
    String? selectedPricingType,
  }) {
    final newSlots = slots ?? this.slots;
    final trafficLevel = newSlots.isNotEmpty
        ? newSlots.where((slot) => slot.isOccupied).length / newSlots.length
        : 0.0;

    return copyWith(
      status: ApiStatus.success,
      slots: slots,
      activeTickets: activeTickets,
      selectedPricingType: selectedPricingType,
      trafficLevel: trafficLevel,
      errorMessage: () => null,
    );
  }

  ParkingState parkVehicle(ParkingTicket ticket) {
    return copyWith(
      lastParkedTicket: () => ticket,
      activeTickets: [...activeTickets, ticket],
      slots: slots
          .map((slot) =>
              slot.id == ticket.slotId ? slot.copyWith(isOccupied: true) : slot)
          .toList(),
    );
  }

  ParkingState unparkVehicle(int slotId, double price, String pricingStrategy) {
    return copyWith(
      lastUnparkResult: () => UnparkResult(
        price: price,
        pricingStrategy: pricingStrategy,
      ),
      activeTickets: activeTickets.where((t) => t.slotId != slotId).toList(),
      slots: slots
          .map((slot) =>
              slot.id == slotId ? slot.copyWith(isOccupied: false) : slot)
          .toList(),
    );
  }
}

class UnparkResult {
  final double price;
  final String pricingStrategy;

  const UnparkResult({
    required this.price,
    required this.pricingStrategy,
  });
}
