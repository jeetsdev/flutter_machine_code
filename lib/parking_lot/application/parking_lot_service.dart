import '../domain/parking_lot_repository.dart';
import '../domain/parking_slot.dart';

class ParkingLotService {
  final ParkingLotRepository repository;

  ParkingLotService(this.repository);

  List<ParkingSlot> getAllSlots() => repository.getAllSlots();

  /// Returns null if successful, otherwise returns error string
  String? bookSlot(int? slotId, String vehicleNumber) {
    if (slotId == null || vehicleNumber.isEmpty) {
      return 'Please select a slot and enter vehicle number.';
    }
    try {
      repository.bookSlot(slotId, vehicleNumber);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Returns null if successful, otherwise returns error string
  String? unparkSlot(int slotId) {
    try {
      repository.unparkSlot(slotId);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  bool isFull() => repository.isFull();
}
