enum SlotStatus { available, occupied }

class ParkingSlot {
  final int id;
  SlotStatus status;
  String? vehicleNumber;

  ParkingSlot(
      {required this.id,
      this.status = SlotStatus.available,
      this.vehicleNumber});
}
