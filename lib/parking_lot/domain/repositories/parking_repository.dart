import '../entities/entry_gate.dart';
import '../entities/parking_lot.dart';
import '../entities/parking_slot.dart';
import '../entities/vehicle.dart';

abstract class ParkingRepository {
  /// Get the parking lot information
  Future<ParkingLot> getParkingLot();

  /// Find the nearest available parking slot for a vehicle from a specific entry gate
  Future<ParkingSlot?> findNearestAvailableSlot(
      Vehicle vehicle, EntryGate entryGate);

  /// Park a vehicle in a specific slot
  Future<bool> parkVehicle(Vehicle vehicle, String slotId);

  /// Unpark a vehicle from its current slot
  Future<Vehicle?> unparkVehicle(String vehicleId);

  /// Get all available slots
  Future<List<ParkingSlot>> getAvailableSlots();

  /// Get all occupied slots
  Future<List<ParkingSlot>> getOccupiedSlots();

  /// Get parking lot status
  Future<Map<String, dynamic>> getParkingLotStatus();
}
