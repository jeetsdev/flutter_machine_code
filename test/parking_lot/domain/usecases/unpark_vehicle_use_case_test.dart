import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';
import 'package:test_app/parking_lot/domain/usecases/unpark_vehicle_use_case.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

void main() {
  late MockParkingRepository mockRepository;
  late UnparkVehicleUseCase unparkVehicleUseCase;
  final fixedDateTime = DateTime(2025, 7, 6, 12, 0); // Fixed time for testing

  setUp(() {
    mockRepository = MockParkingRepository();
    unparkVehicleUseCase = UnparkVehicleUseCase(mockRepository);
  });

  group('UnparkVehicleUseCase', () {
    test('should calculate hourly price correctly with no traffic', () async {
      // Arrange
      final entryTime = fixedDateTime.subtract(const Duration(hours: 2));
      final ticket = ParkingTicket(slotId: 1, entryTime: entryTime);

      when(() => mockRepository.getTrafficLevel()).thenAnswer((_) async => 0.0);
      when(() => mockRepository.unparkVehicle(ticket))
          .thenAnswer((_) async => 15.0);

      // Act
      final price = await unparkVehicleUseCase.execute(ticket, 'hourly');
      print(price);
      // Assert
      expect(price, equals(15.0));
      verify(() => mockRepository.getTrafficLevel()).called(1);
      verify(() => mockRepository.unparkVehicle(ticket)).called(1);
    });

    test('should calculate hourly price correctly with high traffic', () async {
      // Arrange
      final entryTime = fixedDateTime.subtract(const Duration(hours: 2));
      final ticket = ParkingTicket(slotId: 1, entryTime: entryTime);

      when(() => mockRepository.getTrafficLevel()).thenAnswer((_) async => 0.8);
      when(() => mockRepository.unparkVehicle(ticket))
          .thenAnswer((_) async => 18.0);

      // Act
      final price = await unparkVehicleUseCase.execute(ticket, 'hourly');

      // Assert
      expect(price, equals(18.0));
      verify(() => mockRepository.getTrafficLevel()).called(1);
      verify(() => mockRepository.unparkVehicle(ticket)).called(1);
    });

    test('should calculate daily price correctly', () async {
      // Arrange
      final entryTime =
          fixedDateTime.subtract(const Duration(days: 1, hours: 2));
      final ticket = ParkingTicket(slotId: 1, entryTime: entryTime);

      when(() => mockRepository.getTrafficLevel()).thenAnswer((_) async => 0.0);
      when(() => mockRepository.unparkVehicle(ticket))
          .thenAnswer((_) async => 40.0);

      // Act
      final price = await unparkVehicleUseCase.execute(ticket, 'daily');

      // Assert
      expect(price, equals(40.0));
      verify(() => mockRepository.getTrafficLevel()).called(1);
      verify(() => mockRepository.unparkVehicle(ticket)).called(1);
    });

    test('should handle VIP pricing correctly', () async {
      // Arrange
      final entryTime = fixedDateTime.subtract(const Duration(hours: 5));
      final ticket = ParkingTicket(slotId: 1, entryTime: entryTime);

      when(() => mockRepository.getTrafficLevel()).thenAnswer((_) async => 0.0);
      when(() => mockRepository.unparkVehicle(ticket))
          .thenAnswer((_) async => 100.0);

      // Act
      final price = await unparkVehicleUseCase.execute(ticket, 'vip');

      // Assert
      expect(price, equals(100.0));
      verify(() => mockRepository.getTrafficLevel()).called(1);
      verify(() => mockRepository.unparkVehicle(ticket)).called(1);
    });

    test('should handle failed unparking operation', () async {
      // Arrange
      final ticket = ParkingTicket(slotId: 1, entryTime: fixedDateTime);
      when(() => mockRepository.getTrafficLevel())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => unparkVehicleUseCase.execute(ticket, 'hourly'),
        throwsA(isA<Exception>().having(
          (e) {
            print(e);
            return e.toString();
          },
          'message',
          contains('Failed to unpark vehicle'),
        )),
      );
      verify(() => mockRepository.getTrafficLevel()).called(1);
      verifyNever(() => mockRepository.unparkVehicle(ticket));
    });
  });
}
