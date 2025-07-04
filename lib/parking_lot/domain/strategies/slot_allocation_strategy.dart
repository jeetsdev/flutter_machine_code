import '../../domain/entities/entry_gate.dart';
import '../../domain/entities/parking_slot.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_size.dart';

abstract class SlotAllocationStrategy {
  ParkingSlot? allocate(
      List<ParkingSlot> slots, Vehicle vehicle, EntryGate gate);
}

class NearestSlotAllocationStrategy implements SlotAllocationStrategy {
  @override
  ParkingSlot? allocate(
      List<ParkingSlot> slots, Vehicle vehicle, EntryGate gate) {
    List<SlotSize> preferredSizes = _getPreferredSlotOrder(vehicle.size);

    List<ParkingSlot> availableCompatibleSlots = slots
        .where((slot) =>
            slot.isAvailable &&
            preferredSizes.contains(slot.size) &&
            slot.canAccommodate(vehicle))
        .toList();

    if (availableCompatibleSlots.isEmpty) {
      return null;
    }

    // Sort slots by distance from the entry gate
    availableCompatibleSlots.sort((a, b) {
      // First, prioritize slots that match the exact size needed
      if (a.size == preferredSizes.first && b.size != preferredSizes.first) {
        return -1;
      }
      if (b.size == preferredSizes.first && a.size != preferredSizes.first) {
        return 1;
      }

      // Then, sort by distance from the entry gate
      return a.distanceFromEntrance.compareTo(b.distanceFromEntrance);
    });

    return availableCompatibleSlots.first;
  }

  List<SlotSize> _getPreferredSlotOrder(VehicleSize vehicleSize) {
    switch (vehicleSize) {
      case VehicleSize.small:
        return [SlotSize.small, SlotSize.medium, SlotSize.large];
      case VehicleSize.medium:
        return [SlotSize.medium, SlotSize.large];
      case VehicleSize.large:
        return [SlotSize.large];
    }
  }
}
