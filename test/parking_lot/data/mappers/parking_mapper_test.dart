import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/parking_lot/data/mappers/parking_mapper.dart';
import 'package:test_app/parking_lot/data/models/parking_dto.dart';

void main() {
  group('ParkingSlotMapper', () {
    test('maps ParkingSlotDto to ParkingSlot', () {
      final dto = ParkingSlotDto(id: 1, isVip: true, isOccupied: false);
      final slot = dto.toDomain();
      expect(slot.id, 1);
      expect(slot.isVip, true);
      expect(slot.isOccupied, false);
    });
  });

  group('ParkingTicketMapper', () {
    test('maps ParkingTicketDto to ParkingTicket', () {
      final dto = ParkingTicketDto(
          ticketId: 't1',
          slotId: 2,
          entryTime: '2023-01-01T12:00:00.000',
          exitTime: null,
          price: 10.0);
      final ticket = dto.toDomain();
      expect(ticket.slotId, 2);
      expect(ticket.entryTime, DateTime.parse('2023-01-01T12:00:00.000'));
      expect(ticket.exitTime, null);
      expect(ticket.price, 10.0);
    });
  });

  group('ParkingSlotListMapper', () {
    test('maps list of ParkingSlotDto to list of ParkingSlot', () {
      final dtos = [ParkingSlotDto(id: 1, isVip: false, isOccupied: false)];
      final slots = dtos.toDomain();
      expect(slots.length, 1);
      expect(slots.first.id, 1);
    });
  });

  group('ParkingTicketListMapper', () {
    test('maps list of ParkingTicketDto to list of ParkingTicket', () {
      final dtos = [
        ParkingTicketDto(
            ticketId: 't2',
            slotId: 1,
            entryTime: '2023-01-01T12:00:00.000',
            exitTime: null,
            price: 5.0)
      ];
      final tickets = dtos.toDomain();
      expect(tickets.length, 1);
      expect(tickets.first.slotId, 1);
    });
  });
}
