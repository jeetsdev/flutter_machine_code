import '../models/parking_slot_base.dart';

// Factory for creating parking slots - follows Factory Pattern
abstract class ParkingSlotFactory {
  static ParkingSlot createSlot({
    required String size,
    required String id,
    required SlotStatus status,
    required int floor,
    required int row,
    required int column,
  }) {
    switch (size.toLowerCase()) {
      case 'small':
        return SmallParkingSlot(
          id: id,
          status: status,
          floor: floor,
          row: row,
          column: column,
        );
      case 'medium':
        return MediumParkingSlot(
          id: id,
          status: status,
          floor: floor,
          row: row,
          column: column,
        );
      case 'large':
        return LargeParkingSlot(
          id: id,
          status: status,
          floor: floor,
          row: row,
          column: column,
        );
      default:
        throw ArgumentError(
            'Invalid slot size: $size. Valid sizes are: small, medium, large');
    }
  }

  // Method to get available slot sizes
  static List<String> getAvailableSlotSizes() {
    return ['small', 'medium', 'large'];
  }

  // Method to validate slot size
  static bool isValidSlotSize(String size) {
    return getAvailableSlotSizes().contains(size.toLowerCase());
  }
}
