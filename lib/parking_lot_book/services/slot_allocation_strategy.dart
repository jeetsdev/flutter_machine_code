
import 'package:test_app/parking_lot_book/models/vehicle.dart';

import '../models/parking_slot_base.dart';

// Strategy Pattern for parking slot allocation
abstract class ParkingStrategy {
  ParkingSlot? findSlot(
      Vehicle car, Map<String, List<ParkingSlot>> slotsBySize);
}

// Default parking strategy that follows the smart allocation rules
class DefaultParkingStrategy implements ParkingStrategy {
  @override
  ParkingSlot? findSlot(
      Vehicle car, Map<String, List<ParkingSlot>> slotsBySize) {
    final carSize = car.getSizeCategory();

    // Get preferred slot sizes based on car size
    final preferredSlotSizes = _getPreferredSlotSizes(carSize);

    // Try to find a slot in order of preference
    for (final slotSize in preferredSlotSizes) {
      final availableSlots = slotsBySize[slotSize] ?? [];

      for (final slot in availableSlots) {
        if (slot.isAvailable && slot.canAccommodateVehicle(car)) {
          return slot;
        }
      }
    }

    return null;
  }

  // Get preferred slot sizes based on car size
  List<String> _getPreferredSlotSizes(String carSize) {
    switch (carSize) {
      case 'small':
        // Small cars prefer small slots first, then medium, then large
        return ['small', 'medium', 'large'];
      case 'medium':
        // Medium cars prefer medium slots first, then large
        return ['medium', 'large'];
      case 'large':
        // Large cars can only use large slots
        return ['large'];
      default:
        return ['small', 'medium', 'large'];
    }
  }
}

// Nearest parking strategy that considers proximity to entry
class NearestParkingStrategy implements ParkingStrategy {
  final int entryFloor;
  final int entryRow;
  final int entryColumn;

  NearestParkingStrategy({
    this.entryFloor = 1,
    this.entryRow = 1,
    this.entryColumn = 1,
  });

  @override
  ParkingSlot? findSlot(
      Vehicle car, Map<String, List<ParkingSlot>> slotsBySize) {
    final carSize = car.getSizeCategory();
    final preferredSlotSizes = _getPreferredSlotSizes(carSize);

    ParkingSlot? nearestSlot;
    double minDistance = double.infinity;

    // Check all preferred slot sizes
    for (final slotSize in preferredSlotSizes) {
      final availableSlots = slotsBySize[slotSize] ?? [];

      for (final slot in availableSlots) {
        if (slot.isAvailable && slot.canAccommodateVehicle(car)) {
          final distance = _calculateDistance(slot);

          if (distance < minDistance) {
            minDistance = distance;
            nearestSlot = slot;
          }
        }
      }
    }

    return nearestSlot;
  }

  double _calculateDistance(ParkingSlot slot) {
    // Calculate Euclidean distance with floor penalty
    final dx = (slot.column - entryColumn).abs();
    final dy = (slot.row - entryRow).abs();
    final dz = (slot.floor - entryFloor).abs() * 10; // Floor penalty

    return (dx * dx + dy * dy + dz * dz).toDouble();
  }

  List<String> _getPreferredSlotSizes(String carSize) {
    switch (carSize) {
      case 'small':
        return ['small', 'medium', 'large'];
      case 'medium':
        return ['medium', 'large'];
      case 'large':
        return ['large'];
      default:
        return ['small', 'medium', 'large'];
    }
  }
}

// // Premium parking strategy (prefers larger slots for better experience)
// class PremiumParkingStrategy implements ParkingStrategy {
//   @override
//   ParkingSlot? findSlot(Vehicle car, Map<String, List<ParkingSlot>> slotsBySize) {
//     final carSize = car.getSizeCategory();
    
//     // Premium strategy prefers larger slots when available
//     List<String> preferredSlotSizes;
//     switch (carSize) {
//       case 'small':
//         // Small cars prefer large slots first for premium experience
//         preferredSlotSizes = ['large', 'medium', 'small'];
//         break;
//       case 'medium':
//         // Medium cars prefer large slots first
//         preferredSlotSizes = ['large', 'medium'];
//         break;
//       case 'large':
//         // Large cars can only use large slots
//         preferredSlotSizes = ['large'];
//         break;
//       default:
//         preferredSlotSizes = ['large', 'medium', 'small'];
//     }
    
//     // Try to find a slot in order of preference
//     for (final slotSize in preferredSlotSizes) {
//       final availableSlots = slotsBySize[slotSize] ?? [];
      
//       for (final slot in availableSlots) {
//         if (slot.isAvailable && slot.canAccommodateVehicle(carSize)) {
//           return slot;
//         }
//       }
//     }
    
//     return null;
//   }
// }

// // Compact parking strategy (prefers exact size match to maximize occupancy)
// class CompactParkingStrategy implements ParkingStrategy {
//   @override
//   ParkingSlot? findSlot(Vehicle car, Map<String, List<ParkingSlot>> slotsBySize) {
//     final carSize = car.getSizeCategory();
    
//     // Compact strategy prioritizes exact size matches
//     final exactSizeSlots = slotsBySize[carSize] ?? [];
    
//     // First try exact size match
//     for (final slot in exactSizeSlots) {
//       if (slot.isAvailable && slot.canAccommodateVehicle(carSize)) {
//         return slot;
//       }
//     }
    
//     // If no exact match, fall back to larger slots (but only if necessary)
//     if (carSize == 'small') {
//       // Try medium slots
//       final mediumSlots = slotsBySize['medium'] ?? [];
//       for (final slot in mediumSlots) {
//         if (slot.isAvailable && slot.canAccommodateVehicle(carSize)) {
//           return slot;
//         }
//       }
      
//       // Try large slots as last resort
//       final largeSlots = slotsBySize['large'] ?? [];
//       for (final slot in largeSlots) {
//         if (slot.isAvailable && slot.canAccommodateVehicle(carSize)) {
//           return slot;
//         }
//       }
//     } else if (carSize == 'medium') {
//       // Try large slots
//       final largeSlots = slotsBySize['large'] ?? [];
//       for (final slot in largeSlots) {
//         if (slot.isAvailable && slot.canAccommodateVehicle(carSize)) {
//           return slot;
//         }
//       }
//     }
    
//     return null;
//   }
// }
