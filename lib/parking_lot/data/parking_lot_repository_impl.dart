import '../domain/parking_lot_repository.dart';
import '../domain/parking_slot.dart';

class ParkingLotRepositoryImpl implements ParkingLotRepository {
  final List<ParkingSlot> _slots;
  final int capacity;

  ParkingLotRepositoryImpl({this.capacity = 10})
      : _slots =
            List.generate(capacity, (index) => ParkingSlot(id: index + 10));

  @override
  List<ParkingSlot> getAllSlots() => _slots;

  @override
  void bookSlot(int slotId, String vehicleNumber) {
    final slot = _slots.firstWhere((s) => s.id == slotId);
    if (slot.status == SlotStatus.available) {
      slot.status = SlotStatus.occupied;
      slot.vehicleNumber = vehicleNumber;
    } else {
      throw Exception('Slot already occupied');
    }
  }

  @override
  void unparkSlot(int slotId) {
    final slot = _slots.firstWhere((s) => s.id == slotId);
    if (slot.status == SlotStatus.occupied) {
      slot.status = SlotStatus.available;
      slot.vehicleNumber = null;
    } else {
      throw Exception('Slot already available');
    }
  }

  @override
  bool isFull() => _slots.every((s) => s.status == SlotStatus.occupied);
}
