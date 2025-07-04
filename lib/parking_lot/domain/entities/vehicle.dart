import 'vehicle_size.dart';

abstract class Vehicle {
  final String id;
  final String licensePlate;
  final VehicleSize size;

  const Vehicle({
    required this.id,
    required this.licensePlate,
    required this.size,
  });

  List<SlotSize> get compatibleSlotSizes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Vehicle(id: $id, licensePlate: $licensePlate, size: $size)';
}

class SmallVehicle extends Vehicle {
  const SmallVehicle({
    required super.id,
    required super.licensePlate,
  }) : super(size: VehicleSize.small);

  @override
  List<SlotSize> get compatibleSlotSizes =>
      [SlotSize.small, SlotSize.medium, SlotSize.large];
}

class MediumVehicle extends Vehicle {
  const MediumVehicle({
    required super.id,
    required super.licensePlate,
  }) : super(size: VehicleSize.medium);

  @override
  List<SlotSize> get compatibleSlotSizes => [SlotSize.medium, SlotSize.large];
}

class LargeVehicle extends Vehicle {
  const LargeVehicle({
    required super.id,
    required super.licensePlate,
  }) : super(size: VehicleSize.large);

  @override
  List<SlotSize> get compatibleSlotSizes => [SlotSize.large];
}

// Factory Pattern Implementation
abstract class VehicleFactory {
  static Vehicle createVehicle({
    required VehicleSize size,
    required String id,
    required String licensePlate,
  }) {
    switch (size) {
      case VehicleSize.small:
        return SmallVehicle(id: id, licensePlate: licensePlate);
      case VehicleSize.medium:
        return MediumVehicle(id: id, licensePlate: licensePlate);
      case VehicleSize.large:
        return LargeVehicle(id: id, licensePlate: licensePlate);
    }
  }
}
