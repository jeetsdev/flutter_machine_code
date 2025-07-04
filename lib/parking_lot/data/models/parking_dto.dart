import '../../domain/entities/vehicle_entities.dart';

class ParkingSlotDto {
  final int id;
  final SlotSize size;
  final SlotType type;
  final bool isOccupied;
  final String? occupiedBy;

  ParkingSlotDto({
    required this.id,
    required this.size,
    this.type = SlotType.regular,
    required this.isOccupied,
    this.occupiedBy,
  });

  factory ParkingSlotDto.fromJson(Map<String, dynamic> json) {
    return ParkingSlotDto(
      id: json['id'] as int,
      size: SlotSize.values.byName((json['size'] as String).toLowerCase()),
      type: SlotType.values.byName((json['type'] as String).toLowerCase()),
      isOccupied: json['isOccupied'] as bool,
      occupiedBy: json['occupiedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size.name,
      'type': type.name,
      'isOccupied': isOccupied,
      'occupiedBy': occupiedBy,
    };
  }
}

class ParkingTicketDto {
  final String id;
  final String licensePlate;
  final int slotId;
  final String entryTime;
  final VehicleSize vehicleSize;
  final VehicleType vehicleType;
  final String? exitTime;
  final double? price;

  ParkingTicketDto({
    required this.id,
    required this.licensePlate,
    required this.slotId,
    required this.entryTime,
    required this.vehicleSize,
    required this.vehicleType,
    this.exitTime,
    this.price,
  });

  factory ParkingTicketDto.fromJson(Map<String, dynamic> json) {
    return ParkingTicketDto(
      id: json['id'] as String,
      licensePlate: json['licensePlate'] as String,
      slotId: json['slotId'] as int,
      entryTime: json['entryTime'] as String,
      vehicleSize: VehicleSize.values
          .byName((json['vehicleSize'] as String).toLowerCase()),
      vehicleType: VehicleType.values
          .byName((json['vehicleType'] as String).toLowerCase()),
      exitTime: json['exitTime'] as String?,
      price: json['price'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'licensePlate': licensePlate,
      'slotId': slotId,
      'entryTime': entryTime,
      'vehicleSize': vehicleSize.name,
      'vehicleType': vehicleType.name,
      'exitTime': exitTime,
      'price': price,
    };
  }
}

class TrafficLevelDto {
  final double trafficLevel;
  final int occupiedSlots;
  final int totalSlots;

  TrafficLevelDto({
    required this.trafficLevel,
    required this.occupiedSlots,
    required this.totalSlots,
  });

  factory TrafficLevelDto.fromJson(Map<String, dynamic> json) {
    return TrafficLevelDto(
      trafficLevel: json['trafficLevel'] as double,
      occupiedSlots: json['occupiedSlots'] as int,
      totalSlots: json['totalSlots'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trafficLevel': trafficLevel,
      'occupiedSlots': occupiedSlots,
      'totalSlots': totalSlots,
    };
  }
}
