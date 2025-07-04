import '../models/car_types.dart';
import '../models/vehicle.dart';

// Factory for creating vehicles - follows Factory Pattern and Open/Closed Principle
abstract class VehicleFactory {
  static Vehicle createCar({
    required String size,
    required String licensePlate,
    required String color,
    required DateTime entryTime,
  }) {
    switch (size.toLowerCase()) {
      case 'small':
        return SmallCar(
          licensePlate: licensePlate,
          color: color,
          entryTime: entryTime,
        );
      case 'medium':
        return MediumCar(
          licensePlate: licensePlate,
          color: color,
          entryTime: entryTime,
        );
      case 'large':
        return LargeCar(
          licensePlate: licensePlate,
          color: color,
          entryTime: entryTime,
        );
      default:
        throw ArgumentError(
            'Invalid car size: $size. Valid sizes are: small, medium, large');
    }
  }

  // Method to get available car sizes
  static List<String> getAvailableCarSizes() {
    return ['small', 'medium', 'large'];
  }

  // Method to validate car size
  static bool isValidCarSize(String size) {
    return getAvailableCarSizes().contains(size.toLowerCase());
  }
}
