import '../entities/parking_slot.dart';

abstract class IParkingRepository {
  List<ParkingSlot> getAllSlots();
  bool parkVehicle(int slotId, String vehicleNumber);
  bool unparkVehicle(int slotId);
  bool isSlotAvailable(int slotId);
  int getAvailableSlotsCount();
}
