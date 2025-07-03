// Domain Layer: Parking Slot Assignment Strategies

import '../entities/vehicle_entities.dart';

abstract class ParkingAssignmentStrategy {
  ParkingSlot? findSlot(Vehicle vehicle, List<ParkingSlot> availableSlots);
}

class DefaultParkingStrategy implements ParkingAssignmentStrategy {
  @override
  ParkingSlot? findSlot(Vehicle vehicle, List<ParkingSlot> availableSlots) {
    // First, filter slots by vehicle type requirements
    var eligibleSlots = availableSlots
        .where((slot) => !slot.isOccupied && vehicle.canFitInSlot(slot))
        .toList();

    if (eligibleSlots.isEmpty) return null;

    // Sort slots by size to optimize space usage
    eligibleSlots.sort((a, b) {
      // First, prioritize slots matching vehicle type
      if (vehicle.type == VehicleType.vip) {
        if (a.isVip != b.isVip) return a.isVip ? -1 : 1;
      } else if (vehicle.type == VehicleType.handicapped) {
        if (a.isHandicapped != b.isHandicapped) return a.isHandicapped ? -1 : 1;
      }

      // Then, prioritize smallest suitable slot
      return _slotSizeValue(a.size) - _slotSizeValue(b.size);
    });

    return eligibleSlots.first;
  }

  int _slotSizeValue(SlotSize size) {
    switch (size) {
      case SlotSize.small:
        return 1;
      case SlotSize.medium:
        return 2;
      case SlotSize.large:
        return 3;
    }
  }
}

class NearestEntranceParkingStrategy implements ParkingAssignmentStrategy {
  final Map<int, double> _distanceToEntrance;

  NearestEntranceParkingStrategy(this._distanceToEntrance);

  @override
  ParkingSlot? findSlot(Vehicle vehicle, List<ParkingSlot> availableSlots) {
    var eligibleSlots = availableSlots
        .where((slot) => !slot.isOccupied && vehicle.canFitInSlot(slot))
        .toList();

    if (eligibleSlots.isEmpty) return null;

    // Sort by distance to entrance
    eligibleSlots.sort((a, b) {
      final distanceA = _distanceToEntrance[a.id] ?? double.infinity;
      final distanceB = _distanceToEntrance[b.id] ?? double.infinity;
      return distanceA.compareTo(distanceB);
    });

    return eligibleSlots.first;
  }
}

class HandicappedPreferenceParkingStrategy
    implements ParkingAssignmentStrategy {
  final ParkingAssignmentStrategy _baseStrategy;

  HandicappedPreferenceParkingStrategy(this._baseStrategy);

  @override
  ParkingSlot? findSlot(Vehicle vehicle, List<ParkingSlot> availableSlots) {
    if (vehicle.type == VehicleType.handicapped) {
      // First try to find a handicapped slot
      var handicappedSlots = availableSlots
          .where((slot) =>
              !slot.isOccupied &&
              slot.type == SlotType.handicapped &&
              vehicle.canFitInSlot(slot))
          .toList();

      if (handicappedSlots.isNotEmpty) {
        return handicappedSlots.first;
      }
    }

    // Fall back to base strategy if no suitable handicapped slot found
    return _baseStrategy.findSlot(vehicle, availableSlots);
  }
}

class VipPreferenceParkingStrategy implements ParkingAssignmentStrategy {
  final ParkingAssignmentStrategy _baseStrategy;

  VipPreferenceParkingStrategy(this._baseStrategy);

  @override
  ParkingSlot? findSlot(Vehicle vehicle, List<ParkingSlot> availableSlots) {
    if (vehicle.type == VehicleType.vip) {
      // First try to find a VIP slot
      var vipSlots = availableSlots
          .where((slot) =>
              !slot.isOccupied &&
              slot.type == SlotType.vip &&
              vehicle.canFitInSlot(slot))
          .toList();

      if (vipSlots.isNotEmpty) {
        return vipSlots.first;
      }
    }

    // Fall back to base strategy if no suitable VIP slot found
    return _baseStrategy.findSlot(vehicle, availableSlots);
  }
}

// Factory for creating parking strategies
class ParkingStrategyFactory {
  static ParkingAssignmentStrategy createStrategy({
    bool prioritizeHandicapped = true,
    bool prioritizeVip = true,
    Map<int, double>? distanceToEntrance,
  }) {
    ParkingAssignmentStrategy strategy;

    if (distanceToEntrance != null) {
      strategy = NearestEntranceParkingStrategy(distanceToEntrance);
    } else {
      strategy = DefaultParkingStrategy();
    }

    if (prioritizeHandicapped) {
      strategy = HandicappedPreferenceParkingStrategy(strategy);
    }

    if (prioritizeVip) {
      strategy = VipPreferenceParkingStrategy(strategy);
    }

    return strategy;
  }
}
