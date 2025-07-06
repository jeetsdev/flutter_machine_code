// // Domain Layer: Parking Slot Entities

// abstract class ParkingSlot {
//   final int id;
//   final SlotType type;
//   bool isOccupied;
//   String? occupiedBy;

//   ParkingSlot({
//     required this.id,
//     this.type = SlotType.regular,
//     this.isOccupied = false,
//     this.occupiedBy,
//   });

//   bool canAccommodateVehicle(Vehicle vehicle);
//   bool get isVip => type == SlotType.vip;
//   bool get isHandicapped => type == SlotType.handicapped;

//   ParkingSlot copyWith({
//     int? id,
//     SlotType? type,
//     bool? isOccupied,
//     String? occupiedBy,
//   });
// }

// class SmallParkingSlot extends ParkingSlot {
//   SmallParkingSlot({
//     required super.id,
//     super.type = SlotType.regular,
//     super.isOccupied,
//     super.occupiedBy,
//   });

//   @override
//   bool canAccommodateVehicle(Vehicle vehicle) {
//     if (vehicle.type == VehicleType.vip && !isVip) return false;
//     if (vehicle.type == VehicleType.handicapped && !isHandicapped) return false;
//     return vehicle.size == VehicleSize.small;
//   }

//   @override
//   ParkingSlot copyWith({
//     int? id,
//     SlotType? type,
//     bool? isOccupied,
//     String? occupiedBy,
//   }) {
//     return SmallParkingSlot(
//       id: id ?? this.id,
//       type: type ?? this.type,
//       isOccupied: isOccupied ?? this.isOccupied,
//       occupiedBy: occupiedBy ?? this.occupiedBy,
//     );
//   }
// }

// class MediumParkingSlot extends ParkingSlot {
//   MediumParkingSlot({
//     required super.id,
//     super.type = SlotType.regular,
//     super.isOccupied,
//     super.occupiedBy,
//   });

//   @override
//   bool canAccommodateVehicle(Vehicle vehicle) {
//     if (vehicle.type == VehicleType.vip && !isVip) return false;
//     if (vehicle.type == VehicleType.handicapped && !isHandicapped) return false;
//     return vehicle.size == VehicleSize.small ||
//         vehicle.size == VehicleSize.medium;
//   }

//   @override
//   ParkingSlot copyWith({
//     int? id,
//     SlotType? type,
//     bool? isOccupied,
//     String? occupiedBy,
//   }) {
//     return MediumParkingSlot(
//       id: id ?? this.id,
//       type: type ?? this.type,
//       isOccupied: isOccupied ?? this.isOccupied,
//       occupiedBy: occupiedBy ?? this.occupiedBy,
//     );
//   }
// }

// class LargeParkingSlot extends ParkingSlot {
//   LargeParkingSlot({
//     required super.id,
//     super.type = SlotType.regular,
//     super.isOccupied,
//     super.occupiedBy,
//   });

//   @override
//   bool canAccommodateVehicle(Vehicle vehicle) {
//     if (vehicle.type == VehicleType.vip && !isVip) return false;
//     if (vehicle.type == VehicleType.handicapped && !isHandicapped) return false;
//     // Can accommodate any size of vehicle
//     return true;
//   }

//   @override
//   ParkingSlot copyWith({
//     int? id,
//     SlotType? type,
//     bool? isOccupied,
//     String? occupiedBy,
//   }) {
//     return LargeParkingSlot(
//       id: id ?? this.id,
//       type: type ?? this.type,
//       isOccupied: isOccupied ?? this.isOccupied,
//       occupiedBy: occupiedBy ?? this.occupiedBy,
//     );
//   }
// }
