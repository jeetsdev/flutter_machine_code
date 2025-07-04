class ParkingSlot {
  final int id;
  final bool isOccupied;
  final String? vehicleNumber;
  final DateTime? parkedAt;

  ParkingSlot({
    required this.id,
    this.isOccupied = false,
    this.vehicleNumber,
    this.parkedAt,
  });

  ParkingSlot copyWith({
    bool? isOccupied,
    String? vehicleNumber,
    DateTime? parkedAt,
  }) {
    return ParkingSlot(
      id: id,
      isOccupied: isOccupied ?? this.isOccupied,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      parkedAt: parkedAt ?? this.parkedAt,
    );
  }
}
