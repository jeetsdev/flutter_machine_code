// Presentation Layer: BLoC States

import '../../domain/entities/vehicle_entities.dart';

abstract class ParkingState {
  final String? message; // For success/info messages
  const ParkingState({this.message});
}

class ParkingInitial extends ParkingState {
  const ParkingInitial() : super();
}

class ParkingLoading extends ParkingState {
  const ParkingLoading() : super();
}

class ParkingLoaded extends ParkingState {
  final List<ParkingSlot> slots;
  final List<ParkingTicket> activeTickets;
  final String selectedPricingType;
  final double trafficLevel;

  const ParkingLoaded({
    required this.slots,
    required this.activeTickets,
    this.selectedPricingType = 'hourly',
    this.trafficLevel = 0.0,
    super.message,
  });

  ParkingLoaded copyWith({
    List<ParkingSlot>? slots,
    List<ParkingTicket>? activeTickets,
    String? selectedPricingType,
    double? trafficLevel,
    String? message,
  }) {
    return ParkingLoaded(
      slots: slots ?? this.slots,
      activeTickets: activeTickets ?? this.activeTickets,
      selectedPricingType: selectedPricingType ?? this.selectedPricingType,
      trafficLevel: trafficLevel ?? this.trafficLevel,
      message: message,
    );
  }
}

class ParkingError extends ParkingState {
  ParkingError(String message) : super(message: message);
}

class VehicleParked extends ParkingState {
  final ParkingTicket ticket;
  VehicleParked(this.ticket, String message) : super(message: message);
}

class VehicleUnparked extends ParkingState {
  final double price;
  final String pricingStrategy;
  VehicleUnparked(this.price, this.pricingStrategy, String message)
      : super(message: message);
}
