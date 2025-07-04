// Presentation Layer: BLoC Events

import '../../domain/entities/parking_entities.dart';

abstract class ParkingEvent {}

class LoadParkingSlots extends ParkingEvent {
  final int slotId;
  LoadParkingSlots({this.slotId = 0});
}

class ParkVehicle extends ParkingEvent {
  final int slotId;
  ParkVehicle(this.slotId);
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
