import 'entry_gate.dart';
import 'parking_slot.dart';
import 'vehicle.dart';

class ParkingLot {
  final String id;
  final String name;
  final List<EntryGate> entryGates;
  final List<ParkingSlot> allSlots;

  const ParkingLot({
    required this.id,
    required this.name,
    required this.entryGates,
    required this.allSlots,
  });

  int get totalCapacity => allSlots.length;
  int get occupiedSlots => allSlots.where((slot) => slot.isOccupied).length;
  int get availableSlots => totalCapacity - occupiedSlots;

  List<ParkingSlot> getAvailableSlots() =>
      allSlots.where((slot) => slot.isAvailable).toList();

  List<ParkingSlot> getOccupiedSlots() =>
      allSlots.where((slot) => slot.isOccupied).toList();

  ParkingSlot? findSlotById(String slotId) {
    try {
      return allSlots.firstWhere((slot) => slot.id == slotId);
    } catch (e) {
      return null;
    }
  }

  Vehicle? findVehicleById(String vehicleId) {
    for (final slot in allSlots) {
      if (slot.parkedVehicle?.id == vehicleId) {
        return slot.parkedVehicle;
      }
    }
    return null;
  }

  @override
  String toString() =>
      'ParkingLot(id: $id, name: $name, capacity: $totalCapacity, occupied: $occupiedSlots)';
}
