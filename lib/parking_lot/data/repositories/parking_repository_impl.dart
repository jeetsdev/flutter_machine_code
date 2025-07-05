import 'package:test_app/core/network/injection.dart';

import '../../domain/entities/parking_entities.dart';
import '../../domain/repositories/parking_repository.dart';
import '../mappers/parking_mapper.dart';
import '../models/parking_dto.dart';
import '../remote/parking_remote_source.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  late final ParkingRemoteSource _remoteSource;
  ParkingRepositoryImpl(){
    _remoteSource = sl<ParkingRemoteSource>();
  }

  @override
  Future<List<ParkingSlot>> getAvailableSlots() async {
    final response = await _remoteSource.getAvailableSlots();
    final dtos =
        response.data.map((json) => ParkingSlotDto.fromJson(json)).toList();
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
