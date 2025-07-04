import 'package:equatable/equatable.dart';

import 'parking_slot_base.dart';

// Abstract Vehicle class following Open/Closed Principle
abstract class Vehicle extends Equatable {
  final String licensePlate;
  final String color;
  final DateTime entryTime;

  const Vehicle({
    required this.licensePlate,
    required this.color,
    required this.entryTime,
  });

  @override
  List<Object?> get props => [licensePlate, color, entryTime];

  @override
  String toString() {
    return 'Vehicle(licensePlate: $licensePlate, color: $color, type: $runtimeType)';
  }

  // Template method pattern - subclasses can override specific behavior
  double calculateBaseFare();

  // Common method for all vehicles
  Duration getParkedDuration() {
    return DateTime.now().difference(entryTime);
  }

  // Abstract method to get vehicle size category
  String getSizeCategory();

  // Abstract method to check if vehicle can fit in a slot
  bool canFitInSlot(ParkingSlot slot);
}

// Abstract Car class
abstract class Car extends Vehicle {
  const Car({
    required super.licensePlate,
    required super.color,
    required super.entryTime,
  });
}
