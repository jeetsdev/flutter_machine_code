import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';
import 'package:test_app/parking_lot/domain/usecases/park_vehicle_use_case.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

void main() {
  late MockParkingRepository mockRepository;
  late ParkVehicleUseCase parkVehicleUseCase;

  setUp(() {
    mockRepository = MockParkingRepository();
    parkVehicleUseCase = ParkVehicleUseCase(mockRepository);
  });

  group('ParkVehicleUseCase', () {
    test('should park vehicle when slot is available', () async {
      // Arrange
      const slotId = 1;
      final availableSlots = [ParkingSlot(id: slotId)];
      final expectedTicket =
          ParkingTicket(slotId: slotId, entryTime: DateTime.now());

      when(() => mockRepository.getAvailableSlots())
          .thenAnswer((_) async => availableSlots);
      when(() => mockRepository.parkVehicle(slotId))
          .thenAnswer((_) async => expectedTicket);

      // Act
      final result = await parkVehicleUseCase.execute(slotId);

      // Assert
      expect(result.slotId, equals(slotId));
      expect(result, isA<ParkingTicket>());
      verify(() => mockRepository.getAvailableSlots()).called(1);
      verify(() => mockRepository.parkVehicle(slotId)).called(1);
    });

    test('should throw exception when slot is not available', () async {
      // Arrange
      const slotId = 1;
      when(() => mockRepository.getAvailableSlots())
          .thenAnswer((_) async => []);

      // Act & Assert
      expect(
        () => parkVehicleUseCase.execute(slotId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Slot $slotId is not available'),
        )),
      );
      verify(() => mockRepository.getAvailableSlots()).called(1);
      verifyNever(() => mockRepository.parkVehicle(any()));
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      const slotId = 1;
      when(() => mockRepository.getAvailableSlots())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => parkVehicleUseCase.execute(slotId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to park vehicle'),
        )),
      );
      verify(() => mockRepository.getAvailableSlots()).called(1);
      verifyNever(() => mockRepository.parkVehicle(any()));
    });
  });
}
