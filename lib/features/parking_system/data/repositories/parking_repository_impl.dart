import '../../domain/entities/parking_slot.dart';
import '../../domain/repositories/parking_repository.dart';

class ParkingRepository implements IParkingRepository {
  final List<ParkingSlot> _slots;
  static const int totalSlots = 10; // Can be configured as needed

  ParkingRepository()
      : _slots = List.generate(
          totalSlots,
          (index) => ParkingSlot(id: index + 1),
        );

  @override
  List<ParkingSlot> getAllSlots() => List.unmodifiable(_slots);

  @override
  bool parkVehicle(int slotId, String vehicleNumber) {
    final index = _slots.indexWhere((slot) => slot.id == slotId);
    if (index == -1 || _slots[index].isOccupied) return false;

    _slots[index] = _slots[index].copyWith(
      isOccupied: true,
      vehicleNumber: vehicleNumber,
      parkedAt: DateTime.now(),
    );
    return true;
  }

  @override
  bool unparkVehicle(int slotId) {
    final index = _slots.indexWhere((slot) => slot.id == slotId);
    if (index == -1 || !_slots[index].isOccupied) return false;

    _slots[index] = _slots[index].copyWith(
      isOccupied: false,
      vehicleNumber: null,
      parkedAt: null,
    );
    return true;
  }

  @override
  bool isSlotAvailable(int slotId) {
    final index = _slots.indexWhere((slot) => slot.id == slotId);
    if (index == -1) return false;
    return !_slots[index].isOccupied;
  }

  @override
  int getAvailableSlotsCount() {
    return _slots.where((slot) => !slot.isOccupied).length;
  }
}
