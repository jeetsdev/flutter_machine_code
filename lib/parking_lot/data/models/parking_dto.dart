class ParkingSlotDto {
  final int id;
  final bool isVip;
  final bool isOccupied;

  ParkingSlotDto({
    required this.id,
    required this.isVip,
    required this.isOccupied,
  });

  factory ParkingSlotDto.fromJson(Map<String, dynamic> json) {
    return ParkingSlotDto(
      id: json['id'] as int,
      isVip: json['isVip'] as bool,
      isOccupied: json['isOccupied'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isVip': isVip,
      'isOccupied': isOccupied,
    };
  }
}

class ParkingTicketDto {
  final String ticketId;
  final int slotId;
  final String entryTime;
  final String? exitTime;
  final double? price;

  ParkingTicketDto({
    required this.ticketId,
    required this.slotId,
    required this.entryTime,
    this.exitTime,
    this.price,
  });

  factory ParkingTicketDto.fromJson(Map<String, dynamic> json) {
    return ParkingTicketDto(
      ticketId: json['ticketId'] as String,
      slotId: json['slotId'] as int,
      entryTime: json['entryTime'] as String,
      exitTime: json['exitTime'] as String?,
      price: json['price'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'slotId': slotId,
      'entryTime': entryTime,
      if (exitTime != null) 'exitTime': exitTime,
      if (price != null) 'price': price,
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
