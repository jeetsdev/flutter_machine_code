import 'parking_slot.dart';

abstract class ParkingLotRepository {
  List<ParkingSlot> getAllSlots();
  void bookSlot(int slotId, String vehicleNumber);
  void unparkSlot(int slotId);
  bool isFull();
}
