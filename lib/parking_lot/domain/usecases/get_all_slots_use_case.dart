// Domain Layer: Use Cases

import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';

class GetAllSlotsUseCase {
  final ParkingRepository repository;

  GetAllSlotsUseCase(this.repository);

  Future<List<ParkingSlot>> execute() async {
    try {
      return await repository.getAllSlots();
    } catch (e) {
      throw Exception('Failed to get all slots: $e');
    }
  }
}
