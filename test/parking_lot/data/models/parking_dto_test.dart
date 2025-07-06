import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/parking_lot/data/models/parking_dto.dart';

void main() {
  group('ParkingSlotDto', () {
    test('fromJson and toJson', () {
      final json = {'id': 1, 'isVip': true, 'isOccupied': false};
      final dto = ParkingSlotDto.fromJson(json);
      expect(dto.id, 1);
      expect(dto.isVip, true);
      expect(dto.isOccupied, false);
      expect(dto.toJson(), json);
    });
  });

  group('ParkingTicketDto', () {
    test('fromJson and toJson', () {
      final json = {
        'ticketId': 't1',
        'slotId': 2,
        'entryTime': '2023-01-01T12:00:00.000',
        'exitTime': null,
        'price': 10.0
      };
      final dto = ParkingTicketDto.fromJson({...json, 'exitTime': null});
      expect(dto.ticketId, 't1');
      expect(dto.slotId, 2);
      expect(dto.entryTime, '2023-01-01T12:00:00.000');
      expect(dto.exitTime, null);
      expect(dto.price, 10.0);
      expect(dto.toJson()['ticketId'], 't1');
    });
  });

  group('TrafficLevelDto', () {
    test('fromJson and toJson', () {
      final json = {'trafficLevel': 0.7, 'occupiedSlots': 7, 'totalSlots': 10};
      final dto = TrafficLevelDto.fromJson(json);
      expect(dto.trafficLevel, 0.7);
      expect(dto.occupiedSlots, 7);
      expect(dto.totalSlots, 10);
      expect(dto.toJson(), json);
    });
  });
}
