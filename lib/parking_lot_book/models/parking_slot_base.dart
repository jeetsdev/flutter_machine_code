import 'package:equatable/equatable.dart';
import 'package:test_app/parking_lot_book/models/car_types.dart';
import 'package:test_app/parking_lot_book/models/vehicle.dart';

enum SlotStatus {
  available,
  occupied,
  underMaintenance,
}

// Abstract ParkingSlot class following Open/Closed Principle
abstract class ParkingSlot extends Equatable {
  final String id;
  final SlotStatus status;
  final int floor;
  final int row;
  final int column;

  const ParkingSlot({
    required this.id,
    required this.status,
    required this.floor,
    required this.row,
    required this.column,
  });

  @override
  List<Object?> get props => [id, status, floor, row, column];

  bool get isAvailable => status == SlotStatus.available;

  // Abstract method to get slot size category
  String getSizeCategory();

  // Abstract method to check if it can accommodate a vehicle
  bool canAccommodateVehicle(Vehicle vehicleSizeCategory);

  @override
  String toString() {
    return 'ParkingSlot(id: $id, type: $runtimeType, status: $status, floor: $floor, row: $row, col: $column)';
  }
}

// Small Parking Slot
class SmallParkingSlot extends ParkingSlot {
  const SmallParkingSlot({
    required super.id,
    required super.status,
    required super.floor,
    required super.row,
    required super.column,
  });

  @override
  String getSizeCategory() => 'small';

  @override
  bool canAccommodateVehicle(Vehicle vehicleSizeCategory) {
    // Small slots can only accommodate small vehicles
    return isAvailable && vehicleSizeCategory is SmallCar;
  }

  SmallParkingSlot copyWith({
    String? id,
    SlotStatus? status,
    int? floor,
    int? row,
    int? column,
  }) {
    return SmallParkingSlot(
      id: id ?? this.id,
      status: status ?? this.status,
      floor: floor ?? this.floor,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }
}

// Medium Parking Slot
class MediumParkingSlot extends ParkingSlot {
  const MediumParkingSlot({
    required super.id,
    required super.status,
    required super.floor,
    required super.row,
    required super.column,
  });

  @override
  String getSizeCategory() => 'medium';

  @override
  bool canAccommodateVehicle(Vehicle vehicleSizeCategory) {
    // Medium slots can accommodate small and medium vehicles
    return isAvailable &&
        (vehicleSizeCategory is SmallCar  || vehicleSizeCategory is MediumCar);
  }

  MediumParkingSlot copyWith({
    String? id,
    SlotStatus? status,
    int? floor,
    int? row,
    int? column,
  }) {
    return MediumParkingSlot(
      id: id ?? this.id,
      status: status ?? this.status,
      floor: floor ?? this.floor,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }
}

// Large Parking Slot
class LargeParkingSlot extends ParkingSlot {
  const LargeParkingSlot({
    required super.id,
    required super.status,
    required super.floor,
    required super.row,
    required super.column,
  });

  @override
  String getSizeCategory() => 'large';

  @override
  bool canAccommodateVehicle(Vehicle vehicleSizeCategory) {
    // Large slots can accommodate any size vehicle
    return isAvailable;
  }

  LargeParkingSlot copyWith({
    String? id,
    SlotStatus? status,
    int? floor,
    int? row,
    int? column,
  }) {
    return LargeParkingSlot(
      id: id ?? this.id,
      status: status ?? this.status,
      floor: floor ?? this.floor,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }
}
