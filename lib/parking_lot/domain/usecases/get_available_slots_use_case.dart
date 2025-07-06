// Domain Layer: Use Cases

import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';

class GetAvailableSlotsUseCase {
  final ParkingRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<List<ParkingSlot>> execute() async {
    try {
      return await repository.getAvailableSlots();
    } catch (e) {
      throw Exception('Failed to get available slots: $e');
    }
  }
}
