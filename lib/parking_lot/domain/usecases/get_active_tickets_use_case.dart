// Domain Layer: Use Cases

import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';

class GetActiveTicketsUseCase {
  final ParkingRepository repository;

  GetActiveTicketsUseCase(this.repository);

  Future<List<ParkingTicket>> execute() async {
    try {
      return await repository.getActiveTickets();
    } catch (e) {
      throw Exception('Failed to get active tickets: $e');
    }
  }
}

