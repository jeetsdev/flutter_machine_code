import 'package:test_app/core/network/injection.dart';

import '../../domain/entities/parking_entities.dart';
import '../../domain/repositories/parking_repository.dart';
import '../mappers/parking_mapper.dart';
import '../models/parking_dto.dart';
import '../remote/parking_remote_source.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  late final ParkingRemoteSource _remoteSource;
  ParkingRepositoryImpl({ParkingRemoteSource? remoteSource}) {
    _remoteSource = remoteSource ?? sl<ParkingRemoteSource>();
  }

  @override
  Future<List<ParkingSlot>> getAvailableSlots() async {
    final response = await _remoteSource.getAvailableSlots();

    final dtos =
        response.data.map((json) => ParkingSlotDto.fromJson(json)).toList();
    print("dtos is $dtos");
    print("dtos type is ${dtos.runtimeType}");
    return dtos.toDomain();
  }

  @override
  Future<List<ParkingSlot>> getAllSlots() async {
    final response = await _remoteSource.getAllSlots();
    final dtos =
        response.data.map((json) => ParkingSlotDto.fromJson(json)).toList();
    return dtos.toDomain();
  }

  @override
  Future<ParkingTicket> parkVehicle(int slotId) async {
    final response = await _remoteSource.parkVehicle(slotId);
    final dto = ParkingTicketDto.fromJson(response.data);
    return dto.toDomain();
  }

  @override
  Future<double> unparkVehicle(ParkingTicket ticket) async {
    final response = await _remoteSource
        .unparkVehicle('TKT-123'); // In real app, ticket would have ID
    return response.data['price'] as double;
  }

  @override
  Future<List<ParkingTicket>> getActiveTickets() async {
    final response = await _remoteSource.getActiveTickets();
    final dtos =
        response.data.map((json) => ParkingTicketDto.fromJson(json)).toList();
    return dtos.toDomain();
  }

  @override
  Future<double> getTrafficLevel() async {
    final response = await _remoteSource.getTrafficLevel();
    final trafficDto = TrafficLevelDto.fromJson(response.data);
    return trafficDto.trafficLevel;
  }
}

// test('should handle complete flow from RemoteSource to DTO', () async {
//       // Arrange
//       final mockData = [
//         {'id': '1', 'title': 'Integration Test Todo', 'isDone': true},
//       ];
//       when(() => mockRemoteSource.fetchTodos())
//           .thenAnswer((_) async => mockData);

//       // Act
//       final result = await repository.fetchTodos();

//       // Assert
//       expect(result, hasLength(1));
//       expect(result.first, isA<TodoDTO>());
//       expect(result.first.id, equals('1'));
//       expect(result.first.title, equals('Integration Test Todo'));
//       expect(result.first.isDone, equals(true));

//       // Verify the complete chain: RemoteSource -> JSON -> TodoEntity -> TodoDTO
//       verify(() => mockRemoteSource.fetchTodos()).called(1);
//     });

//     test('should maintain data integrity through the conversion pipeline',
//         () async {
//       // Arrange
//       final mockData = [
//         {'id': '1', 'title': 'Pipeline Test', 'isDone': false},
//         {'id': '2', 'title': 'Another Test', 'isDone': true},
//       ];
//       when(() => mockRemoteSource.fetchTodos())
//           .thenAnswer((_) async => mockData);

//       // Act
//       final result = await repository.fetchTodos();

//       // Assert
//       expect(result, hasLength(2));
//       expect(result, isA<List<TodoDTO>>());

//       // Verify that data flows correctly through the pipeline
//       expect(result[0].id, equals(mockData[0]['id']));
//       expect(result[0].title, equals(mockData[0]['title']));
//       expect(result[0].isDone, equals(mockData[0]['isDone']));
//       expect(result[1].id, equals(mockData[1]['id']));
//       expect(result[1].title, equals(mockData[1]['title']));
//       expect(result[1].isDone, equals(mockData[1]['isDone']));
//     });
