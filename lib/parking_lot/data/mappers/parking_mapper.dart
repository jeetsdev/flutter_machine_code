import '../../domain/entities/vehicle_entities.dart';
import '../models/parking_dto.dart';

extension ParkingSlotMapper on ParkingSlotDto {
  ParkingSlot toDomain() {
    return ParkingSlot(
      id: id,
      size: size,
      type: type,
      isOccupied: isOccupied,
      occupiedBy: occupiedBy,
    );
  }
}

extension ParkingTicketMapper on ParkingTicketDto {
  ParkingTicket toDomain() {
    return ParkingTicket(
      id: id,
      licensePlate: licensePlate,
      slotId: slotId,
      entryTime: DateTime.parse(entryTime),
      vehicleSize: vehicleSize,
      vehicleType: vehicleType,
      exitTime: exitTime != null ? DateTime.parse(exitTime!) : null,
      price: price,
    );
  }
}

extension ParkingSlotListMapper on List<ParkingSlotDto> {
  List<ParkingSlot> toDomain() {
    return map((dto) => dto.toDomain()).toList();
  }
}

extension ParkingTicketListMapper on List<ParkingTicketDto> {
  List<ParkingTicket> toDomain() {
    return map((dto) => dto.toDomain()).toList();
  }
}
