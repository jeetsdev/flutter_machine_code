import 'vehicle.dart';
import 'vehicle_size.dart';

abstract class ParkingSlot {
  final String id;
  final SlotSize size;
  final double distanceFromEntrance;
  Vehicle? _parkedVehicle;

  ParkingSlot({
    required this.id,
    required this.size,
    required this.distanceFromEntrance,
  });

  bool get isOccupied => _parkedVehicle != null;
  bool get isAvailable => !isOccupied;
  Vehicle? get parkedVehicle => _parkedVehicle;

  bool canAccommodate(Vehicle vehicle);

  void park(Vehicle vehicle) {
    if (isOccupied) {
      throw Exception('Slot $id is already occupied');
    }
    if (!canAccommodate(vehicle)) {
      throw Exception('Vehicle ${vehicle.id} cannot fit in slot $id');
    }
    _parkedVehicle = vehicle;
  }

  Vehicle? unpark() {
    final vehicle = _parkedVehicle;
    _parkedVehicle = null;
    return vehicle;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkingSlot &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ParkingSlot(id: $id, size: $size, occupied: $isOccupied, distance: $distanceFromEntrance)';
}

class SmallParkingSlot extends ParkingSlot {
  SmallParkingSlot({
    required super.id,
    required super.distanceFromEntrance,
  }) : super(size: SlotSize.small);

  @override
  bool canAccommodate(Vehicle vehicle) => vehicle.size == VehicleSize.small;
}

class MediumParkingSlot extends ParkingSlot {
  MediumParkingSlot({
    required super.id,
    required super.distanceFromEntrance,
  }) : super(size: SlotSize.medium);

  @override
  bool canAccommodate(Vehicle vehicle) =>
      vehicle.size == VehicleSize.small || vehicle.size == VehicleSize.medium;
}

class LargeParkingSlot extends ParkingSlot {
  LargeParkingSlot({
    required super.id,
    required super.distanceFromEntrance,
  }) : super(size: SlotSize.large);

  @override
  bool canAccommodate(Vehicle vehicle) => true; // Can accommodate all sizes
}

// Factory Pattern Implementation
abstract class ParkingSlotFactory {
  static ParkingSlot createSlot({
    required SlotSize size,
    required String id,
    required double distanceFromEntrance,
  }) {
    switch (size) {
      case SlotSize.small:
        return SmallParkingSlot(
          id: id,
          distanceFromEntrance: distanceFromEntrance,
        );
      case SlotSize.medium:
        return MediumParkingSlot(
          id: id,
          distanceFromEntrance: distanceFromEntrance,
        );
      case SlotSize.large:
        return LargeParkingSlot(
          id: id,
          distanceFromEntrance: distanceFromEntrance,
        );
    }
  }
}
