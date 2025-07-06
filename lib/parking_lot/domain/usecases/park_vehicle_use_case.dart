import '../entities/parking_entities.dart';
import '../repositories/parking_repository.dart';

class ParkVehicleUseCase {
  final ParkingRepository repository;

  ParkVehicleUseCase(this.repository);

  Future<ParkingTicket> execute(int slotId) async {
    try {
      final availableSlots = await repository.getAvailableSlots();
      final targetSlot = availableSlots.firstWhere(
        (slot) => slot.id == slotId,
        orElse: () => throw Exception('Slot $slotId is not available'),
      );

      return await repository.parkVehicle(slotId);
    } catch (e) {
      throw Exception('Failed to park vehicle: $e');
    }
  }
}
