// Presentation Layer: BLoC States

import '../../domain/entities/parking_entities.dart';

abstract class ParkingState {}

class ParkingInitial extends ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingLoaded extends ParkingState {
  final List<ParkingSlot> slots;
  final List<ParkingTicket> activeTickets;
  final String selectedPricingType;
  final double trafficLevel;

  ParkingLoaded({
    required this.slots,
    required this.activeTickets,
    this.selectedPricingType = 'hourly',
    this.trafficLevel = 0.0,
  });

  ParkingLoaded copyWith({
    List<ParkingSlot>? slots,
    List<ParkingTicket>? activeTickets,
    String? selectedPricingType,
    double? trafficLevel,
  }) {
    return ParkingLoaded(
      slots: slots ?? this.slots,
      activeTickets: activeTickets ?? this.activeTickets,
      selectedPricingType: selectedPricingType ?? this.selectedPricingType,
      trafficLevel: trafficLevel ?? this.trafficLevel,
    );
  }
}

class ParkingError extends ParkingState {
  final String message;
  ParkingError(this.message);
}

class VehicleParked extends ParkingState {
  final ParkingTicket ticket;
  VehicleParked(this.ticket);
}

class VehicleUnparked extends ParkingState {
  final double price;
  final String pricingStrategy;
  VehicleUnparked(this.price, this.pricingStrategy);
}
