// Domain Layer: Vehicle Entities

enum VehicleSize { small, medium, large }

enum VehicleType { regular, vip, handicapped }

class Vehicle {
  final String licensePlate;
  final VehicleSize size;
  final VehicleType type;

  Vehicle({
    required this.licensePlate,
    required this.size,
    this.type = VehicleType.regular,
  });

  bool canFitInSlot(ParkingSlot slot) {
    if (type == VehicleType.vip && !slot.isVip) return false;
    if (type == VehicleType.handicapped && !slot.isHandicapped) return false;

    switch (size) {
      case VehicleSize.small:
        return true; // Can fit in any size slot
      case VehicleSize.medium:
        return slot.size == SlotSize.medium || slot.size == SlotSize.large;
      case VehicleSize.large:
        return slot.size == SlotSize.large;
    }
  }
}

enum SlotSize { small, medium, large }

enum SlotType { regular, vip, handicapped }

class ParkingSlot {
  final int id;
  final SlotSize size;
  final SlotType type;
  bool isOccupied;
  String? occupiedBy; // License plate of parked vehicle

  ParkingSlot({
    required this.id,
    required this.size,
    this.type = SlotType.regular,
    this.isOccupied = false,
    this.occupiedBy,
  });

  bool get isVip => type == SlotType.vip;
  bool get isHandicapped => type == SlotType.handicapped;

  ParkingSlot copyWith({
    int? id,
    SlotSize? size,
    SlotType? type,
    bool? isOccupied,
    String? occupiedBy,
  }) {
    return ParkingSlot(
      id: id ?? this.id,
      size: size ?? this.size,
      type: type ?? this.type,
      isOccupied: isOccupied ?? this.isOccupied,
      occupiedBy: occupiedBy ?? this.occupiedBy,
    );
  }
}

class ParkingTicket {
  final String id;
  final String licensePlate;
  final int slotId;
  final DateTime entryTime;
  final VehicleSize vehicleSize;
  final VehicleType vehicleType;
  DateTime? exitTime;
  double? price;

  ParkingTicket({
    required this.id,
    required this.licensePlate,
    required this.slotId,
    required this.entryTime,
    required this.vehicleSize,
    required this.vehicleType,
    this.exitTime,
    this.price,
  });

  Duration get parkingDuration {
    return (exitTime ?? DateTime.now()).difference(entryTime);
  }

  ParkingTicket copyWith({
    String? id,
    String? licensePlate,
    int? slotId,
    DateTime? entryTime,
    VehicleSize? vehicleSize,
    VehicleType? vehicleType,
    DateTime? exitTime,
    double? price,
  }) {
    return ParkingTicket(
      id: id ?? this.id,
      licensePlate: licensePlate ?? this.licensePlate,
      slotId: slotId ?? this.slotId,
      entryTime: entryTime ?? this.entryTime,
      vehicleSize: vehicleSize ?? this.vehicleSize,
      vehicleType: vehicleType ?? this.vehicleType,
      exitTime: exitTime ?? this.exitTime,
      price: price ?? this.price,
    );
  }
}
