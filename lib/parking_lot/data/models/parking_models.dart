import 'package:test_app/parking_lot/domain/entities/vehicle.dart';

import '../../domain/entities/parking_slot.dart';
import '../../domain/entities/vehicle_size.dart';

class ParkingSlotModel {
  final String id;
  final SlotSize size;
  final double distanceFromEntrance;
  final bool isOccupied;
  final VehicleModel? parkedVehicle;

  ParkingSlotModel({
    required this.id,
    required this.size,
    required this.distanceFromEntrance,
    required this.isOccupied,
    this.parkedVehicle,
  });

  factory ParkingSlotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSlotModel(
      id: json['id'] as String,
      size: SlotSize.values.firstWhere((e) => e.name == json['size']),
      distanceFromEntrance: json['distanceFromEntrance'] as double,
      isOccupied: json['isOccupied'] as bool,
      parkedVehicle: json['parkedVehicle'] != null
          ? VehicleModel.fromJson(json['parkedVehicle'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'size': size.name,
        'distanceFromEntrance': distanceFromEntrance,
        'isOccupied': isOccupied,
        'parkedVehicle': parkedVehicle?.toJson(),
      };

  ParkingSlot toEntity() {
    return ParkingSlotFactory.createSlot(
      id: id,
      size: size,
      distanceFromEntrance: distanceFromEntrance,
    );
  }
}

class VehicleModel {
  final String id;
  final String licensePlate;
  final VehicleSize size;

  VehicleModel({
    required this.id,
    required this.licensePlate,
    required this.size,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      licensePlate: json['licensePlate'] as String,
      size: VehicleSize.values.firstWhere((e) => e.name == json['size']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'licensePlate': licensePlate,
        'size': size.name,
      };

  factory VehicleModel.fromEntity(Vehicle vehicle) {
    return VehicleModel(
      id: vehicle.id,
      licensePlate: vehicle.licensePlate,
      size: vehicle.size,
    );
  }
}
