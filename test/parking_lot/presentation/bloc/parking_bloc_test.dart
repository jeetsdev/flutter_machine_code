// This file contains unit tests for the ParkingBloc using bloc_test package
// bloc_test provides utilities specifically designed for testing BLoCs

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/usecases/get_active_tickets_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/get_all_slots_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/park_vehicle_use_case.dart';
import 'package:test_app/parking_lot/domain/usecases/unpark_vehicle_use_case.dart';
import 'package:test_app/parking_lot/presentation/bloc/parking_bloc.dart';
import 'package:test_app/parking_lot/presentation/bloc/parking_event.dart';
import 'package:test_app/parking_lot/presentation/bloc/parking_state.dart';

// Mock classes for all use cases to simulate their behavior in tests
class MockParkVehicleUseCase extends Mock implements ParkVehicleUseCase {}

class MockUnparkVehicleUseCase extends Mock implements UnparkVehicleUseCase {}

class MockGetAllSlotsUseCase extends Mock implements GetAllSlotsUseCase {}

class MockGetActiveTicketsUseCase extends Mock
    implements GetActiveTicketsUseCase {}

void main() {
  // Declare variables that will be initialized in setUp
  late ParkingBloc parkingBloc;
  late MockParkVehicleUseCase mockParkVehicleUseCase;
  late MockUnparkVehicleUseCase mockUnparkVehicleUseCase;
  late MockGetAllSlotsUseCase mockGetAllSlotsUseCase;
  late MockGetActiveTicketsUseCase mockGetActiveTicketsUseCase;

  // Fixed datetime for consistent testing
  final fixedDateTime = DateTime(2025, 7, 6, 12, 0);

  // Set up fresh instances before each test
  setUp(() {
    // Initialize all mock use cases
    mockParkVehicleUseCase = MockParkVehicleUseCase();
    mockUnparkVehicleUseCase = MockUnparkVehicleUseCase();
    mockGetAllSlotsUseCase = MockGetAllSlotsUseCase();
    mockGetActiveTicketsUseCase = MockGetActiveTicketsUseCase();

    // Create a fresh ParkingBloc instance with mock dependencies
    parkingBloc = ParkingBloc(
      parkVehicleUseCase: mockParkVehicleUseCase,
      unparkVehicleUseCase: mockUnparkVehicleUseCase,
      getAllSlotsUseCase: mockGetAllSlotsUseCase,
      getActiveTicketsUseCase: mockGetActiveTicketsUseCase,
    );
  });

  // Clean up after each test
  tearDown(() {
    parkingBloc.close();
  });

  // Tests for LoadParkingSlots event
  group('LoadParkingSlots', () {
    // Sample test data
    final mockSlots = [
      ParkingSlot(id: 1),
      ParkingSlot(id: 2, isVip: true),
      ParkingSlot(id: 3),
    ];
    final mockActiveTickets = [
      ParkingTicket(slotId: 1, entryTime: fixedDateTime),
    ];

    blocTest<ParkingBloc, ParkingState>(
      'emits [loading, success] when LoadParkingSlots is added successfully',
      build: () {
        // Arrange: Set up mock responses
        when(() => mockGetAllSlotsUseCase.execute())
            .thenAnswer((_) async => mockSlots);
        when(() => mockGetActiveTicketsUseCase.execute())
            .thenAnswer((_) async => mockActiveTickets);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadParkingSlots()),
      expect: () => [
        // First state should be loading
        isA<ParkingState>().having((state) => state.isLoading, 'loading', isTrue),
        // Second state should be success with correct data
        isA<ParkingState>()
            .having((state) => state.isSuccess, 'success', true)
            .having((state) => state.slots, 'slots', mockSlots)
            .having(
              (state) => state.activeTickets,
              'activeTickets',
              mockActiveTickets,
            ),
      ],
      verify: (_) {
        verify(() => mockGetAllSlotsUseCase.execute()).called(1);
        verify(() => mockGetActiveTicketsUseCase.execute()).called(1);
      },
    );

    // Test specific slot status updates
    test('should update slot status when loading with specific slotId',
        () async {
      // Arrange: Set up initial state with mock data
      const targetSlotId = 1;
      final initialState = ParkingState(
        slots: mockSlots,
        status: ApiStatus.success,
      );
      parkingBloc.emit(initialState);

      // Set up mock response for active tickets
      when(() => mockGetActiveTicketsUseCase.execute())
          .thenAnswer((_) async => mockActiveTickets);

      // Assert: Verify state transitions and slot occupation
      expectLater(
        parkingBloc.stream,
        emitsInOrder([
          isA<ParkingState>()
              .having((state) => state.isLoading, 'loading', true),
          isA<ParkingState>()
              .having((state) => state.isSuccess, 'success', true)
              .having(
                (state) => state.slots
                    .firstWhere((s) => s.id == targetSlotId)
                    .isOccupied,
                'slot occupied',
                true,
              ),
        ]),
      );

      // Act: Trigger event with specific slot ID
      parkingBloc.add(LoadParkingSlots(slotId: targetSlotId));
    });

    test('should emit error state when loading fails', () async {
      // Arrange
      when(() => mockGetActiveTicketsUseCase.execute())
          .thenThrow(Exception('Network error'));

      // Assert
      expectLater(
        parkingBloc.stream,
        emitsInOrder([
          isA<ParkingState>()
              .having((state) => state.isLoading, 'loading', true),
          isA<ParkingState>()
              .having((state) => state.isError, 'error', true)
              .having((state) => state.errorMessage, 'error message',
                  contains('Network error')),
        ]),
      );

      // Act
      parkingBloc.add(LoadParkingSlots());
    });
  });

  // Tests for ParkVehicle event
  group('ParkVehicle', () {
    test('should emit success state when parking is successful', () async {
      // Arrange: Set up test data and mock responses
      const slotId = 1;
      final ticket = ParkingTicket(slotId: slotId, entryTime: fixedDateTime);

      // Configure mock responses
      when(() => mockParkVehicleUseCase.execute(slotId))
          .thenAnswer((_) async => ticket);
      when(() => mockGetActiveTicketsUseCase.execute())
          .thenAnswer((_) async => [ticket]);
      when(() => mockGetAllSlotsUseCase.execute())
          .thenAnswer((_) async => [ParkingSlot(id: slotId, isOccupied: true)]);

      // Assert: Verify complete flow including refresh
      expectLater(
        parkingBloc.stream,
        emitsInOrder([
          // Initial loading state
          isA<ParkingState>()
              .having((state) => state.isLoading, 'loading', true),
          // Success state with parked ticket
          isA<ParkingState>()
              .having((state) => state.isSuccess, 'success', true)
              .having((state) => state.lastParkedTicket, 'last ticket',
                  equals(ticket)),
          // Loading state for refresh
          isA<ParkingState>()
              .having((state) => state.isLoading, 'loading again', true),
          // Final success state with updated slot status
          isA<ParkingState>()
              .having((state) => state.isSuccess, 'success after refresh', true)
              .having((state) => state.slots.first.isOccupied, 'slot occupied',
                  true),
        ]),
      );

      // Act: Trigger parking event
      parkingBloc.add(ParkVehicle(slotId));
    });

    test('should emit error state when parking fails', () async {
      // Arrange
      const slotId = 1;
      when(() => mockParkVehicleUseCase.execute(slotId))
          .thenThrow(Exception('Slot not available'));

      // Assert
      expectLater(
        parkingBloc.stream,
        emitsInOrder([
          isA<ParkingState>()
              .having((state) => state.isLoading, 'loading', true),
          isA<ParkingState>()
              .having((state) => state.isError, 'error', true)
              .having((state) => state.errorMessage, 'error message',
                  contains('Slot not available')),
        ]),
      );

      // Act
      parkingBloc.add(ParkVehicle(slotId));
    });
  });

  // Tests for UnparkVehicle event
  group('UnparkVehicle', () {
    const expectedPrice = 10.0;
    const pricingType = 'hourly';

    blocTest<ParkingBloc, ParkingState>(
      'emits [loading, success, loading, success] when unparking is successful',
      build: () {
        final ticket = ParkingTicket(
          slotId: 1,
          entryTime: fixedDateTime,
        );
        when(() => mockUnparkVehicleUseCase.execute(ticket, pricingType))
            .thenAnswer((_) async => expectedPrice);
        when(() => mockGetAllSlotsUseCase.execute())
            .thenAnswer((_) async => [ParkingSlot(id: 1)]);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(
        UnparkVehicle(
          ParkingTicket(slotId: 1, entryTime: fixedDateTime),
          pricingType,
        ),
      ),
      expect: () => [
        // Initial loading state
        isA<ParkingState>().having((state) => state.isLoading, 'loading', true),
        // Success state with price
        isA<ParkingState>()
            .having((state) => state.isSuccess, 'success', true)
            .having(
              (state) => state.lastUnparkResult?.price,
              'unpark price',
              equals(expectedPrice),
            ),
        // Loading state for refresh
        isA<ParkingState>()
            .having((state) => state.isLoading, 'loading again', true),
        // Final success state after refresh
        isA<ParkingState>()
            .having((state) => state.isSuccess, 'success after refresh', true),
      ],
      verify: (_) {
        verify(() => mockUnparkVehicleUseCase.execute(any(), pricingType))
            .called(1);
        verify(() => mockGetAllSlotsUseCase.execute()).called(1);
      },
    );

    blocTest<ParkingBloc, ParkingState>(
      'emits [loading, error] when unparking fails',
      build: () {
        final ticket = ParkingTicket(slotId: 1, entryTime: fixedDateTime);
        when(() => mockUnparkVehicleUseCase.execute(ticket, 'hourly'))
            .thenThrow(Exception('Invalid ticket'));
        return parkingBloc;
      },
      act: (bloc) => bloc.add(
        UnparkVehicle(
          ParkingTicket(slotId: 1, entryTime: fixedDateTime),
          'hourly',
        ),
      ),
      expect: () => [
        isA<ParkingState>().having((state) => state.isLoading, 'loading', true),
        isA<ParkingState>()
            .having((state) => state.isError, 'error', true)
            .having(
              (state) => state.errorMessage,
              'error message',
              contains('Invalid ticket'),
            ),
      ],
      verify: (_) {
        verify(() => mockUnparkVehicleUseCase.execute(any(), 'hourly'))
            .called(1);
        verifyNever(() => mockGetAllSlotsUseCase.execute());
      },
    );
  });

  // Group for testing SelectPricingType event
  group('SelectPricingType', () {
    blocTest<ParkingBloc, ParkingState>(
      'emits [success] with updated pricing type',
      build: () => parkingBloc,
      act: (bloc) => bloc.add(SelectPricingType('vip')),
      expect: () => [
        isA<ParkingState>()
            .having((state) => state.isSuccess, 'success', true)
            .having(
              (state) => state.selectedPricingType,
              'pricing type',
              equals('vip'),
            ),
      ],
    );
  });

  group('RefreshSlots', () {
    final updatedSlots = [
      ParkingSlot(id: 1),
      ParkingSlot(id: 2, isVip: true),
    ];

    blocTest<ParkingBloc, ParkingState>(
      'emits [loading, success] with updated slots',
      build: () {
        when(() => mockGetAllSlotsUseCase.execute())
            .thenAnswer((_) async => updatedSlots);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(RefreshSlots()),
      expect: () => [
        isA<ParkingState>().having((state) => state.isLoading, 'loading', true),
        isA<ParkingState>()
            .having((state) => state.isSuccess, 'success', true)
            .having((state) => state.slots, 'slots', equals(updatedSlots)),
      ],
      verify: (_) {
        verify(() => mockGetAllSlotsUseCase.execute()).called(1);
      },
    );

    blocTest<ParkingBloc, ParkingState>(
      'emits [loading, error] when refresh fails',
      build: () {
        when(() => mockGetAllSlotsUseCase.execute())
            .thenThrow(Exception('Failed to refresh'));
        return parkingBloc;
      },
      act: (bloc) => bloc.add(RefreshSlots()),
      expect: () => [
        isA<ParkingState>().having((state) => state.isLoading, 'loading', true),
        isA<ParkingState>()
            .having((state) => state.isError, 'error', true)
            .having(
              (state) => state.errorMessage,
              'error message',
              contains('Failed to refresh'),
            ),
      ],
      verify: (_) {
        verify(() => mockGetAllSlotsUseCase.execute()).called(1);
      },
    );
  });

  // Group for testing LoadActiveTickets event
  group('LoadActiveTickets', () {
    final activeTickets = [
      ParkingTicket(slotId: 1, entryTime: fixedDateTime),
      ParkingTicket(slotId: 2, entryTime: fixedDateTime),
    ];

    blocTest<ParkingBloc, ParkingState>(
      'emits [loading, success] with updated active tickets',
      build: () {
        when(() => mockGetActiveTicketsUseCase.execute())
            .thenAnswer((_) async => activeTickets);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadActiveTickets()),
      expect: () => [
        isA<ParkingState>().having((state) => state.isLoading, 'loading', true),
        isA<ParkingState>()
            .having((state) => state.isSuccess, 'success', true)
            .having(
              (state) => state.activeTickets,
              'active tickets',
              equals(activeTickets),
            ),
      ],
      verify: (_) {
        verify(() => mockGetActiveTicketsUseCase.execute()).called(1);
      },
    );

    blocTest<ParkingBloc, ParkingState>(
      'emits [loading, error] when loading tickets fails',
      build: () {
        when(() => mockGetActiveTicketsUseCase.execute())
            .thenThrow(Exception('Failed to load tickets'));
        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadActiveTickets()),
      expect: () => [
        isA<ParkingState>().having((state) => state.isLoading, 'loading', true),
        isA<ParkingState>()
            .having((state) => state.isError, 'error', true)
            .having(
              (state) => state.errorMessage,
              'error message',
              contains('Failed to load tickets'),
            ),
      ],
      verify: (_) {
        verify(() => mockGetActiveTicketsUseCase.execute()).called(1);
      },
    );
  });

  group('State calculations', () {
    blocTest<ParkingBloc, ParkingState>(
      'calculates correct traffic level when slots are occupied',
      build: () => parkingBloc,
      act: (bloc) {
        final slots = [
          ParkingSlot(id: 1, isOccupied: true),
          ParkingSlot(id: 2, isOccupied: true),
          ParkingSlot(id: 3, isOccupied: false),
          ParkingSlot(id: 4, isOccupied: false),
        ];
        return bloc.emit(const ParkingState().success(slots: slots));
      },
      verify: (bloc) {
        expect(
            bloc.state.trafficLevel, equals(0.5)); // 2 occupied out of 4 slots
      },
    );

    blocTest<ParkingBloc, ParkingState>(
      'handles traffic level calculation with empty slots',
      build: () => parkingBloc,
      act: (bloc) => bloc.emit(const ParkingState().success(slots: [])),
      verify: (bloc) {
        expect(bloc.state.trafficLevel, equals(0.0));
      },
    );
  });
}
