
import 'package:test_app/parking_lot_book/models/entry_gate.dart';
import 'package:test_app/parking_lot_book/models/vehicle.dart';

import '../models/parking_slot_base.dart';
import '../factories/parking_slot_factory.dart';
import '../strategies/fare_strategy.dart';
import 'slot_allocation_strategy.dart';

// Parking slot assignment result
class SlotAssignmentResult {
  final bool success;
  final ParkingSlot? assignedSlot;
  final String message;

  SlotAssignmentResult({
    required this.success,
    this.assignedSlot,
    required this.message,
  });
}

// Entry gate model


// Parking lot management using Singleton Pattern
class ParkingLotManager {
  static ParkingLotManager? _instance;

  // Private constructor
  ParkingLotManager._internal();

  // Singleton instance getter
  static ParkingLotManager getInstance() {
    _instance ??= ParkingLotManager._internal();
    return _instance!;
  }

  // Parking lot data
  final List<ParkingSlot> _allSlots = [];
  final Map<String, Vehicle> _parkedVehicles = {};
  final List<EntryGate> _entryGates = [];
  final FareCalculator _fareCalculator = FareCalculator(HourlyFareStrategy());
  ParkingStrategy _parkingStrategy = DefaultParkingStrategy();

  // Initialize parking lot with slots and gates
  void initializeParkingLot({
    required int floors,
    required int rowsPerFloor,
    required int slotsPerRow,
    required Map<String, int>
        slotDistribution, // e.g., {'small': 40, 'medium': 40, 'large': 20}
  }) {
    _allSlots.clear();

    final totalSlotsPerFloor = rowsPerFloor * slotsPerRow;

    // Calculate slots per size per floor
    final smallSlotsPerFloor =
        (totalSlotsPerFloor * (slotDistribution['small'] ?? 0) / 100).round();
    final mediumSlotsPerFloor =
        (totalSlotsPerFloor * (slotDistribution['medium'] ?? 0) / 100).round();

    for (int floor = 1; floor <= floors; floor++) {
      int currentSlotCount = 0;

      for (int row = 1; row <= rowsPerFloor; row++) {
        for (int col = 1; col <= slotsPerRow; col++) {
          String slotSize;
          if (currentSlotCount < smallSlotsPerFloor) {
            slotSize = 'small';
          } else if (currentSlotCount <
              smallSlotsPerFloor + mediumSlotsPerFloor) {
            slotSize = 'medium';
          } else {
            slotSize = 'large';
          }

          final slot = ParkingSlotFactory.createSlot(
            size: slotSize,
            id: 'F${floor}_R${row}_C$col',
            status: SlotStatus.available,
            floor: floor,
            row: row,
            column: col,
          );

          _allSlots.add(slot);
          currentSlotCount++;
        }
      }
    }

    // Initialize entry gates
    _entryGates.clear();
    _entryGates.addAll([
      EntryGate(id: 'GATE_1', name: 'North Entry'),
      EntryGate(id: 'GATE_2', name: 'South Entry'),
      EntryGate(id: 'GATE_3', name: 'East Entry'),
      EntryGate(id: 'GATE_4', name: 'West Entry'),
    ]);
  }

  // Find nearest available slot for a vehicle
  SlotAssignmentResult findNearestAvailableSlot(
      Vehicle vehicle, String entryGateId) {
    final vehicleSize = vehicle.getSizeCategory();

    // Organize slots by size for the strategy
    final slotsBySize = <String, List<ParkingSlot>>{
      'small':
          _allSlots.where((slot) => slot.getSizeCategory() == 'small').toList(),
      'medium': _allSlots
          .where((slot) => slot.getSizeCategory() == 'medium')
          .toList(),
      'large':
          _allSlots.where((slot) => slot.getSizeCategory() == 'large').toList(),
    };

    // Use the parking strategy to find the best slot
    final assignedSlot = _parkingStrategy.findSlot(vehicle, slotsBySize);

    if (assignedSlot == null) {
      return SlotAssignmentResult(
        success: false,
        message: 'No available slots for $vehicleSize vehicle',
      );
    }

    return SlotAssignmentResult(
      success: true,
      assignedSlot: assignedSlot,
      message: 'Slot ${assignedSlot.id} assigned successfully',
    );
  }

  // Park a vehicle
  SlotAssignmentResult parkVehicle(Vehicle vehicle, String entryGateId) {
    // Check if vehicle is already parked
    if (_parkedVehicles.containsKey(vehicle.licensePlate)) {
      return SlotAssignmentResult(
        success: false,
        message: 'Vehicle ${vehicle.licensePlate} is already parked',
      );
    }

    // Find available slot
    final slotResult = findNearestAvailableSlot(vehicle, entryGateId);
    if (!slotResult.success || slotResult.assignedSlot == null) {
      return slotResult;
    }

    // Update slot status to occupied
    final slotIndex = _allSlots.indexOf(slotResult.assignedSlot!);
    if (slotResult.assignedSlot! is SmallParkingSlot) {
      _allSlots[slotIndex] =
          (slotResult.assignedSlot! as SmallParkingSlot).copyWith(
        status: SlotStatus.occupied,
      );
    } else if (slotResult.assignedSlot! is MediumParkingSlot) {
      _allSlots[slotIndex] =
          (slotResult.assignedSlot! as MediumParkingSlot).copyWith(
        status: SlotStatus.occupied,
      );
    } else if (slotResult.assignedSlot! is LargeParkingSlot) {
      _allSlots[slotIndex] =
          (slotResult.assignedSlot! as LargeParkingSlot).copyWith(
        status: SlotStatus.occupied,
      );
    }

    // Add vehicle to parked vehicles
    _parkedVehicles[vehicle.licensePlate] = vehicle;

    return SlotAssignmentResult(
      success: true,
      assignedSlot: _allSlots[slotIndex],
      message:
          'Vehicle ${vehicle.licensePlate} parked successfully in slot ${slotResult.assignedSlot!.id}',
    );
  }

  // Remove vehicle and calculate fare
  Map<String, dynamic> removeVehicle(String licensePlate) {
    if (!_parkedVehicles.containsKey(licensePlate)) {
      return {
        'success': false,
        'message': 'Vehicle $licensePlate not found in parking lot',
      };
    }

    final vehicle = _parkedVehicles[licensePlate]!;
    final fare = _fareCalculator.calculateFare(vehicle);
    final parkedDuration = vehicle.getParkedDuration();

    // Find and free the slot
    final slotIndex =
        _allSlots.indexWhere((slot) => slot.status == SlotStatus.occupied);

    if (slotIndex != -1) {
      final slot = _allSlots[slotIndex];
      if (slot is SmallParkingSlot) {
        _allSlots[slotIndex] = slot.copyWith(status: SlotStatus.available);
      } else if (slot is MediumParkingSlot) {
        _allSlots[slotIndex] = slot.copyWith(status: SlotStatus.available);
      } else if (slot is LargeParkingSlot) {
        _allSlots[slotIndex] = slot.copyWith(status: SlotStatus.available);
      }
    }

    // Remove vehicle from parked vehicles
    _parkedVehicles.remove(licensePlate);

    return {
      'success': true,
      'message': 'Vehicle $licensePlate removed successfully',
      'fare': fare,
      'parkedDuration': parkedDuration,
      'vehicle': vehicle,
    };
  }

  // Get parking lot statistics
  Map<String, dynamic> getParkingLotStatistics() {
    final totalSlots = _allSlots.length;
    final occupiedSlots =
        _allSlots.where((slot) => slot.status == SlotStatus.occupied).length;
    final availableSlots = totalSlots - occupiedSlots;

    final smallSlots =
        _allSlots.where((slot) => slot.getSizeCategory() == 'small').length;
    final mediumSlots =
        _allSlots.where((slot) => slot.getSizeCategory() == 'medium').length;
    final largeSlots =
        _allSlots.where((slot) => slot.getSizeCategory() == 'large').length;

    final occupiedSmallSlots = _allSlots
        .where((slot) =>
            slot.getSizeCategory() == 'small' &&
            slot.status == SlotStatus.occupied)
        .length;
    final occupiedMediumSlots = _allSlots
        .where((slot) =>
            slot.getSizeCategory() == 'medium' &&
            slot.status == SlotStatus.occupied)
        .length;
    final occupiedLargeSlots = _allSlots
        .where((slot) =>
            slot.getSizeCategory() == 'large' &&
            slot.status == SlotStatus.occupied)
        .length;

    return {
      'totalSlots': totalSlots,
      'occupiedSlots': occupiedSlots,
      'availableSlots': availableSlots,
      'occupancyRate': totalSlots > 0
          ? (occupiedSlots / totalSlots * 100).toStringAsFixed(1)
          : '0.0',
      'slotDistribution': {
        'small': {
          'total': smallSlots,
          'occupied': occupiedSmallSlots,
          'available': smallSlots - occupiedSmallSlots
        },
        'medium': {
          'total': mediumSlots,
          'occupied': occupiedMediumSlots,
          'available': mediumSlots - occupiedMediumSlots
        },
        'large': {
          'total': largeSlots,
          'occupied': occupiedLargeSlots,
          'available': largeSlots - occupiedLargeSlots
        },
      },
      'parkedVehicles': _parkedVehicles.length,
      'entryGates': _entryGates.length,
    };
  }

  // Get all available entry gates
  List<EntryGate> getEntryGates() => List.unmodifiable(_entryGates);

  // Set fare calculation strategy
  void setFareStrategy(FareStrategy strategy) {
    _fareCalculator.setStrategy(strategy);
  }

  // Set parking strategy
  void setParkingStrategy(ParkingStrategy strategy) {
    _parkingStrategy = strategy;
  }

  // Get currently parked vehicles
  Map<String, Vehicle> getParkedVehicles() => Map.unmodifiable(_parkedVehicles);
}
