class ParkingSlotModel {
  final int id;
  final bool isOccupied;
  final String? vehicleNumber;
  final DateTime? parkedAt;

  ParkingSlotModel({
    required this.id,
    this.isOccupied = false,
    this.vehicleNumber,
    this.parkedAt,
  });

  factory ParkingSlotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSlotModel(
      id: json['id'],
      isOccupied: json['isOccupied'] ?? false,
      vehicleNumber: json['vehicleNumber'],
      parkedAt:
          json['parkedAt'] != null ? DateTime.parse(json['parkedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isOccupied': isOccupied,
      'vehicleNumber': vehicleNumber,
      'parkedAt': parkedAt?.toIso8601String(),
    };
  }

  ParkingSlotModel copyWith({
    bool? isOccupied,
    String? vehicleNumber,
    DateTime? parkedAt,
  }) {
    return ParkingSlotModel(
      id: id,
      isOccupied: isOccupied ?? this.isOccupied,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      parkedAt: parkedAt ?? this.parkedAt,
    );
  }
}
