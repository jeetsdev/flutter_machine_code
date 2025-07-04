import 'vehicle.dart';

// Small Car class
class SmallCar extends Car {
  const SmallCar({
    required super.licensePlate,
    required super.color,
    required super.entryTime,
  });

  @override
  double calculateBaseFare() {
    return 10.0; // Base fare for small cars
  }

  @override
  String getSizeCategory() => 'small';

  @override
  bool canFitInSlot(slot) {
    // Small cars can fit in any slot
    return slot.canAccommodateVehicle(this);
  }

}

// Medium Car class
class MediumCar extends Car {
  const MediumCar({
    required super.licensePlate,
    required super.color,
    required super.entryTime,
  });

  @override
  double calculateBaseFare() {
    return 15.0; // Base fare for medium cars
  }

  @override
  String getSizeCategory() => 'medium';

  @override
  bool canFitInSlot(slot) {
    // Medium cars can fit in medium and large slots
    return slot.canAccommodateVehicle(this);
  }


}

// Large Car class
class LargeCar extends Car {
  const LargeCar({
    required super.licensePlate,
    required super.color,
    required super.entryTime,
  });

  @override
  double calculateBaseFare() {
    return 20.0; // Base fare for large cars
  }

  @override
  String getSizeCategory() => 'large';

  @override
  bool canFitInSlot(slot) {
    // Large cars can only fit in large slots
    return slot.canAccommodateVehicle(this);
  }
}
