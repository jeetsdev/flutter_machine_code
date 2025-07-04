import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

enum SlotSize { small, medium, large }
enum VehicleSize { small, medium, large }


class ParkingSlot {
  final String id;
  final SlotSize size;
  final bool isAvailable;
  final Offset location; // For distance calculation
  ParkingSlot({required this.id, required this.size, required this.isAvailable, required this.location});
}

class Vehicle {
  final String id;
  final VehicleSize size;
  Vehicle({required this.id, required this.size});
}

class EntryGate {
  final String id;
  final Offset location;
  EntryGate({required this.id, required this.location});
}


class AllocateNearestSlotUseCase {
  final List<ParkingSlot> slots;

  AllocateNearestSlotUseCase(this.slots);

  ParkingSlot? execute(Vehicle vehicle, EntryGate gate) {
    List<SlotSize> preferredSizes = _getPreferredSlotOrder(vehicle.size);

    for (final size in preferredSizes) {
      final matchingSlots = slots.where((s) => s.isAvailable && s.size == size).toList();
      if (matchingSlots.isNotEmpty) {
        matchingSlots.sort((a, b) =>
          _distance(gate.location, a.location).compareTo(_distance(gate.location, b.location)));
        return matchingSlots.first;
      }
    }
    return null;
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

  double _distance(Offset a, Offset b) => (a - b).distance;
}


abstract class SlotAllocationStrategy {
  ParkingSlot? allocate(List<ParkingSlot> slots, Vehicle vehicle, EntryGate gate);
}

class NearestFitStrategy implements SlotAllocationStrategy {
  @override
  ParkingSlot? allocate(List<ParkingSlot> slots, Vehicle vehicle, EntryGate gate) {
    return AllocateNearestSlotUseCase(slots).execute(vehicle, gate);
  }
}


class SlotAllocationCubit extends Cubit<ParkingSlot?> {
  final SlotAllocationStrategy strategy;

  SlotAllocationCubit(this.strategy) : super(null);

  void findSlot(List<ParkingSlot> slots, Vehicle vehicle, EntryGate gate) {
    final result = strategy.allocate(slots, vehicle, gate);
    emit(result);
  }
}