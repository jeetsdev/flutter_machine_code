import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';
import 'package:test_app/parking_lot/domain/usecases/get_active_tickets_use_case.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

void main() {
  late MockParkingRepository mockRepository;
  late GetActiveTicketsUseCase getActiveTicketsUseCase;
  final fixedDateTime = DateTime(2025, 7, 6, 12, 0); // Fixed time for testing

  setUp(() {
    mockRepository = MockParkingRepository();
    getActiveTicketsUseCase = GetActiveTicketsUseCase(mockRepository);
  });

  group('GetActiveTicketsUseCase', () {
    test('should return empty list when no active tickets exist', () async {
      // Arrange
      when(() => mockRepository.getActiveTickets()).thenAnswer((_) async => []);

      // Act
      final result = await getActiveTicketsUseCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getActiveTickets()).called(1);
    });

    test('should return list of active tickets with correct data', () async {
      // Arrange
      final expectedTickets = [
        ParkingTicket(
            slotId: 1,
            entryTime: fixedDateTime.subtract(const Duration(hours: 1))),
        ParkingTicket(
            slotId: 2,
            entryTime: fixedDateTime.subtract(const Duration(hours: 2))),
      ];
      when(() => mockRepository.getActiveTickets())
          .thenAnswer((_) async => expectedTickets);

      // Act
      final result = await getActiveTicketsUseCase.execute();

      // Assert
      expect(result, equals(expectedTickets));
      expect(result.length, equals(2));
      expect(result[0].slotId, equals(1));
      expect(result[1].slotId, equals(2));
      expect(result[0].entryTime.difference(result[1].entryTime).inHours,
          equals(1));
      verify(() => mockRepository.getActiveTickets()).called(1);
    });

    test('should handle repository failure', () async {
      // Arrange
      when(() => mockRepository.getActiveTickets())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => getActiveTicketsUseCase.execute(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to get active tickets'),
        )),
      );
      verify(() => mockRepository.getActiveTickets()).called(1);
    });

    test('should maintain ticket order from repository', () async {
      // Arrange
      final expectedTickets = [
        ParkingTicket(slotId: 2, entryTime: fixedDateTime),
        ParkingTicket(slotId: 1, entryTime: fixedDateTime),
      ];
      when(() => mockRepository.getActiveTickets())
          .thenAnswer((_) async => expectedTickets);

      // Act
      final result = await getActiveTicketsUseCase.execute();

      // Assert
      expect(result.map((ticket) => ticket.slotId).toList(), equals([2, 1]));
      verify(() => mockRepository.getActiveTickets()).called(1);
    });

    test('should handle multiple tickets for same slot', () async {
      // Arrange
      final expectedTickets = [
        ParkingTicket(
            slotId: 1,
            entryTime: fixedDateTime.subtract(const Duration(hours: 2))),
        ParkingTicket(
            slotId: 1,
            entryTime: fixedDateTime.subtract(const Duration(hours: 1))),
      ];
      when(() => mockRepository.getActiveTickets())
          .thenAnswer((_) async => expectedTickets);

      // Act
      final result = await getActiveTicketsUseCase.execute();

      // Assert
      expect(result.length, equals(2));
      expect(result.every((ticket) => ticket.slotId == 1), isTrue);
      expect(result[0].entryTime.isBefore(result[1].entryTime), isTrue);
      verify(() => mockRepository.getActiveTickets()).called(1);
    });
  });
}
