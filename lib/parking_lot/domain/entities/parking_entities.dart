// Domain Layer: Common Parking Entities
// Re-export all relevant entities from vehicle_entities.dart
export 'vehicle_entities.dart' show ParkingTicket, Vehicle, VehicleType;

// Parking-specific enums
enum ParkingType { hourly, daily, vip }
