import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';
import 'package:test_app/parking_lot/domain/usecases/get_all_slots_use_case.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

void main() {
  late MockParkingRepository mockRepository;
  late GetAllSlotsUseCase getAllSlotsUseCase;

  setUp(() {
    mockRepository = MockParkingRepository();
    getAllSlotsUseCase = GetAllSlotsUseCase(mockRepository);
  });

  group('GetAllSlotsUseCase', () {
    test('should return empty list when no slots exist', () async {
      // Arrange
      when(() => mockRepository.getAllSlots()).thenAnswer((_) async => []);

      // Act
      final result = await getAllSlotsUseCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getAllSlots()).called(1);
    });

    test('should return list of all slots including occupied ones', () async {
      // Arrange
      final expectedSlots = [
        ParkingSlot(id: 1),
        ParkingSlot(id: 2),
        ParkingSlot(id: 3, isOccupied: true),
      ];
      when(() => mockRepository.getAllSlots())
          .thenAnswer((_) async => expectedSlots);

      // Act
      final result = await getAllSlotsUseCase.execute();

      // Assert
      expect(result, equals(expectedSlots));
      expect(result.length, equals(3));
      expect(result[2].isOccupied, true);
      expect(result.map((slot) => slot.id), containsAll([1, 2, 3]));
      verify(() => mockRepository.getAllSlots()).called(1);
    });

    test('should handle repository failure', () async {
      // Arrange
      when(() => mockRepository.getAllSlots())
          .thenThrow(Exception('Database connection failed'));

      // Act & Assert
      expect(
        () => getAllSlotsUseCase.execute(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to get all slots'),
        )),
      );
      verify(() => mockRepository.getAllSlots()).called(1);
    });

    test('should maintain slot order from repository', () async {
      // Arrange
      final expectedSlots = [
        ParkingSlot(id: 3),
        ParkingSlot(id: 1),
        ParkingSlot(id: 2),
      ];
      when(() => mockRepository.getAllSlots())
          .thenAnswer((_) async => expectedSlots);

      // Act
      final result = await getAllSlotsUseCase.execute();

      // Assert
      expect(result.map((slot) => slot.id).toList(), equals([3, 1, 2]));
      verify(() => mockRepository.getAllSlots()).called(1);
    });
  });
}
