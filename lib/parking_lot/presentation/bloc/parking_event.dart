// Presentation Layer: BLoC Events

import '../../domain/entities/parking_entities.dart';
import '../../domain/entities/vehicle_entities.dart';

abstract class ParkingEvent {}

class LoadParkingSlots extends ParkingEvent {
  final String? pricingType;
  LoadParkingSlots([this.pricingType]);
}

class ParkVehicle extends ParkingEvent {
  final int slotId;
  final Vehicle vehicle;
  ParkVehicle(this.slotId, this.vehicle);
}

class UnparkVehicle extends ParkingEvent {
  final ParkingTicket ticket;
  final String pricingType;
  UnparkVehicle(this.ticket, this.pricingType);
}

class SelectPricingType extends ParkingEvent {
  final String pricingType;
  SelectPricingType(this.pricingType);
}

class RefreshSlots extends ParkingEvent {}

class LoadActiveTickets extends ParkingEvent {}
