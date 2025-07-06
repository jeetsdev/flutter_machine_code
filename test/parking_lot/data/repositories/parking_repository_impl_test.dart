import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/parking_lot/data/models/api_response.dart';
import 'package:test_app/parking_lot/data/models/parking_dto.dart';
import 'package:test_app/parking_lot/data/remote/parking_remote_source.dart';
import 'package:test_app/parking_lot/data/repositories/parking_repository_impl.dart';
import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';

class MockParkingRemoteSource extends Mock implements ParkingRemoteSource {}

void main() {
  late ParkingRepositoryImpl repository;
  late MockParkingRemoteSource mockRemoteSource;

  setUp(() {
    mockRemoteSource = MockParkingRemoteSource();
    repository = ParkingRepositoryImpl(remoteSource: mockRemoteSource);
  });

  group('getAvailableSlots', () {
    // final mockDtoList = [
    //   {'id': 1, 'isVip': false, 'isOccupied': false},
    //   {'id': 2, 'isVip': false, 'isOccupied': false},
    // ];

    // final mockResponse = ApiResponse(
    //   status: 'success',
    //   message: 'Available slots retrieved successfully',
    //   data: mockDtoList,
    // );

    // print("mockResponse.data is ${mockResponse.data}");

    // final List<ParkingSlotDto> dtos =
    //     mockResponse.data.map((json) => ParkingSlotDto.fromJson(json)).toList();

    test('should return list of available ParkingSlot entities when successful',
        () async {
      final mockDtoList = [
        {'id': 1, 'isVip': false, 'isOccupied': false},
        {'id': 2, 'isVip': false, 'isOccupied': false},
      ];

      final mockResponse = ApiResponse(
        status: 'success',
        message: 'Available slots retrieved successfully',
        data: mockDtoList,
      );
      // // Arrange
      when(() => mockRemoteSource.getAvailableSlots())
          .thenAnswer((_) async => mockResponse);
      // when(() => repository.getAvailableSlots())
      //     .thenAnswer((_) async => dtos.toDomain());
      // // Act
      final result = await repository.getAvailableSlots();

      // final finalResult =
      //     result.data.map((json) => ParkingSlotDto.fromJson(json)).toList();

      // Assert
      // expect(result, isA<List<ParkingSlot>>());
      // expect(result.length, equals(2));
      // expect(result[0].id, equals(1));
      // expect(result[0].isVip, isTrue);
      // expect(result[0].isOccupied, isFalse);
      verify(() => mockRemoteSource.getAvailableSlots()).called(1);
    });

    test('should throw exception when remote source fails', () async {
      // Arrange
      when(() => mockRemoteSource.getAvailableSlots())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => repository.getAvailableSlots(), throwsException);
    });
  });

  group('getAllSlots', () {
    final mockDtoList = [
      ParkingSlotDto(id: 1, isVip: true, isOccupied: true),
      ParkingSlotDto(id: 2, isVip: false, isOccupied: false)
    ];
    final mockResponse = ApiResponse(
      status: "success",
      message: "slots fetched successfully",
      data: mockDtoList.map((e) => e.toJson()).toList(),
    );

    test('should return list of all ParkingSlot entities when successful',
        () async {
      // Arrange
      when(() => mockRemoteSource.getAllSlots())
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.getAllSlots();

      // Assert
      expect(result, isA<List<ParkingSlot>>());
      expect(result.length, equals(2));
      expect(result[0].isOccupied, isTrue);
      expect(result[1].isOccupied, isFalse);
      verify(() => mockRemoteSource.getAllSlots()).called(1);
    });

    test('should throw exception when remote source fails', () async {
      // Arrange
      when(() => mockRemoteSource.getAllSlots())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => repository.getAllSlots(), throwsException);
    });
  });

  group('parkVehicle', () {
    final mockTicketDto = ParkingTicketDto(
      ticketId: 'TKT-123',
      slotId: 1,
      entryTime: '2023-12-20T10:00:00Z',
    );
    final mockResponse = ApiResponse(
      status: "success",
      message: "slots fetched successfully",
      data: mockTicketDto.toJson(),
    );

    test('should return ParkingTicket entity when parking is successful',
        () async {
      // Arrange
      when(() => mockRemoteSource.parkVehicle(any()))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.parkVehicle(1);

      // Assert
      expect(result, isA<ParkingTicket>());
      expect(result.slotId, equals(1));
      expect(result.entryTime, isA<DateTime>());
      verify(() => mockRemoteSource.parkVehicle(1)).called(1);
    });

    test('should throw exception when remote source fails', () async {
      // Arrange
      when(() => mockRemoteSource.parkVehicle(any()))
          .thenThrow(Exception('Failed to park'));

      // Act & Assert
      expect(() => repository.parkVehicle(1), throwsException);
    });
  });

  group('unparkVehicle', () {
    final mockResponse = ApiResponse(
      status: "success",
      message: "slots fetched successfully",
      data: {'price': 15.0},
    );

    final mockTicket = ParkingTicket(
      slotId: 1,
      entryTime: DateTime.parse('2023-12-20T10:00:00Z'),
    );

    test('should return price when unparking is successful', () async {
      // Arrange
      when(() => mockRemoteSource.unparkVehicle(any()))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.unparkVehicle(mockTicket);

      // Assert
      expect(result, equals(15.0));
      verify(() => mockRemoteSource.unparkVehicle('TKT-123')).called(1);
    });

    test('should throw exception when remote source fails', () async {
      // Arrange
      when(() => mockRemoteSource.unparkVehicle(any()))
          .thenThrow(Exception('Failed to unpark'));

      // Act & Assert
      expect(() => repository.unparkVehicle(mockTicket), throwsException);
    });
  });

  group('getActiveTickets', () {
    final mockTicketDtoList = [
      ParkingTicketDto(
        ticketId: 'TKT-123',
        slotId: 1,
        entryTime: '2023-12-20T10:00:00Z',
      ),
      ParkingTicketDto(
        ticketId: 'TKT-124',
        slotId: 2,
        entryTime: '2023-12-20T11:00:00Z',
      ),
    ];
    final mockResponse = ApiResponse(
      status: "success",
      message: "slots fetched successfully",
      data: mockTicketDtoList.map((e) => e.toJson()).toList(),
    );

    test('should return list of active ParkingTicket entities when successful',
        () async {
      // Arrange
      when(() => mockRemoteSource.getActiveTickets())
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.getActiveTickets();

      // Assert
      expect(result, isA<List<ParkingTicket>>());
      expect(result.length, equals(2));
      expect(result[0].slotId, equals(1));
      expect(result[1].slotId, equals(2));
      verify(() => mockRemoteSource.getActiveTickets()).called(1);
    });

    test('should throw exception when remote source fails', () async {
      // Arrange
      when(() => mockRemoteSource.getActiveTickets())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => repository.getActiveTickets(), throwsException);
    });
  });

  group('getTrafficLevel', () {
    final mockTrafficDto = TrafficLevelDto(
      trafficLevel: 0.75,
      occupiedSlots: 15,
      totalSlots: 20,
    );

    final mockResponse = ApiResponse(
      status: "success",
      message: "slots fetched successfully",
      data: mockTrafficDto.toJson(),
    );

    test('should return traffic level when successful', () async {
      // Arrange
      when(() => mockRemoteSource.getTrafficLevel())
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.getTrafficLevel();

      // Assert
      expect(result, equals(0.75));
      verify(() => mockRemoteSource.getTrafficLevel()).called(1);
    });

    test('should throw exception when remote source fails', () async {
      // Arrange
      when(() => mockRemoteSource.getTrafficLevel())
          .thenThrow(Exception('Failed to get traffic level'));

      // Act & Assert
      expect(() => repository.getTrafficLevel(), throwsException);
    });
  });
}
