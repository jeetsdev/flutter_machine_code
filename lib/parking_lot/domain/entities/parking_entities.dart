// Domain Layer: Entities

class ParkingSlot {
  final int id;
  final bool isVip;
  bool isOccupied;

  ParkingSlot({required this.id, this.isVip = false, this.isOccupied = false});

  ParkingSlot copyWith({
    int? id,
    bool? isVip,
    bool? isOccupied,
  }) {
    return ParkingSlot(
      id: id ?? this.id,
      isVip: isVip ?? this.isVip,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }
}

class ParkingTicket {
  final int slotId;
  final DateTime entryTime;
  DateTime? exitTime;
  double? price;

  ParkingTicket({
    required this.slotId,
    required this.entryTime,
    this.exitTime,
    this.price,
  });

  ParkingTicket copyWith({
    int? slotId,
    DateTime? entryTime,
    DateTime? exitTime,
    double? price,
  }) {
    return ParkingTicket(
      slotId: slotId ?? this.slotId,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      price: price ?? this.price,
    );
  }
}

class Vehicle {
  final String licensePlate;
  final VehicleType type;

  Vehicle({
    required this.licensePlate,
    required this.type,
  });
}

enum VehicleType { car, motorcycle, truck }

enum ParkingType { hourly, daily, vip }
