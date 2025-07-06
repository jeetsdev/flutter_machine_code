import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';

void main() {
  group('ParkingSlot', () {
    test('copyWith returns a new instance with updated values', () {
      final slot = ParkingSlot(id: 1, isVip: true, isOccupied: false);
      final updated = slot.copyWith(isOccupied: true);
      expect(updated.id, 1);
      expect(updated.isVip, true);
      expect(updated.isOccupied, true);
    });
  });

  group('ParkingTicket', () {
    test('copyWith returns a new instance with updated values', () {
      final ticket = ParkingTicket(slotId: 1, entryTime: DateTime(2023, 1, 1));
      final updated = ticket.copyWith(price: 20.0);
      expect(updated.slotId, 1);
      expect(updated.entryTime, DateTime(2023, 1, 1));
      expect(updated.price, 20.0);
    });
  });

  group('Vehicle', () {
    test('Vehicle stores license plate and type', () {
      final vehicle = Vehicle(licensePlate: 'ABC123', type: VehicleType.car);
      expect(vehicle.licensePlate, 'ABC123');
      expect(vehicle.type, VehicleType.car);
    });
  });
}
