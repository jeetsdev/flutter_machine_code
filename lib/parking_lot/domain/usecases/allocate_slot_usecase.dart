import '../entities/entry_gate.dart';
import '../entities/parking_slot.dart';
import '../entities/vehicle.dart';
import '../strategies/slot_allocation_strategy.dart';

class AllocateSlotUseCase {
  final SlotAllocationStrategy strategy;

  const AllocateSlotUseCase(this.strategy);

  ParkingSlot? call(List<ParkingSlot> slots, Vehicle vehicle, EntryGate gate) {
    return strategy.allocate(slots, vehicle, gate);
  }
}
