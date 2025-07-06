import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';
import 'package:test_app/parking_lot/domain/usecases/get_available_slots_use_case.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

void main() {
  late MockParkingRepository mockRepository;
  late GetAvailableSlotsUseCase getAvailableSlotsUseCase;

  setUp(() {
    mockRepository = MockParkingRepository();
    getAvailableSlotsUseCase = GetAvailableSlotsUseCase(mockRepository);
  });

  group('GetAvailableSlotsUseCase', () {
    test('should return empty list when no slots are available', () async {
      // Arrange
      when(() => mockRepository.getAvailableSlots())
          .thenAnswer((_) async => []);

      // Act
      final result = await getAvailableSlotsUseCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getAvailableSlots()).called(1);
    });

    test('should return list of available slots', () async {
      // Arrange
      final expectedSlots = [
        ParkingSlot(id: 1),
        ParkingSlot(id: 2),
        ParkingSlot(id: 3, isVip: true)
      ];
      when(() => mockRepository.getAvailableSlots())
          .thenAnswer((_) async => expectedSlots);

      // Act
      final result = await getAvailableSlotsUseCase.execute();

      // Assert
      expect(result, equals(expectedSlots));
      expect(result.length, equals(3));
      expect(result[2].isVip, isTrue);
      verify(() => mockRepository.getAvailableSlots()).called(1);
    });

    test('should handle repository failure', () async {
      // Arrange
      when(() => mockRepository.getAvailableSlots())
          .thenThrow(Exception('Failed to fetch slots'));

      // Act & Assert
      expect(
        () => getAvailableSlotsUseCase.execute(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to get available slots'),
        )),
      );
      verify(() => mockRepository.getAvailableSlots()).called(1);
    });
  });
}
