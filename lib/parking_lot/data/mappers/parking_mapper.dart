import '../../domain/entities/parking_entities.dart';
import '../models/parking_dto.dart';

extension ParkingSlotMapper on ParkingSlotDto {
  ParkingSlot toDomain() {
    return ParkingSlot(
      id: id,
      isVip: isVip,
      isOccupied: isOccupied,
    );
  }
}

extension ParkingTicketMapper on ParkingTicketDto {
  ParkingTicket toDomain() {
    return ParkingTicket(
      slotId: slotId,
      entryTime: DateTime.parse(entryTime),
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
