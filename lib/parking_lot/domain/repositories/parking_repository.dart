// Domain Layer: Repository Interface for Remote API Operations

import '../entities/parking_entities.dart';

abstract class ParkingRepository {
  /// Fetch all available parking slots from the server
  Future<List<ParkingSlot>> getAvailableSlots();

  /// Fetch all parking slots (available and occupied) from the server
  Future<List<ParkingSlot>> getAllSlots();

  /// Park a vehicle in the specified slot and create a ticket via API
  Future<ParkingTicket> parkVehicle(int slotId);

  /// Unpark a vehicle and get the final calculated price from the server
  Future<double> unparkVehicle(ParkingTicket ticket);

  /// Fetch all currently active parking tickets from the server
  Future<List<ParkingTicket>> getActiveTickets();

  /// Get the current traffic level (occupancy percentage) from the server
  Future<double> getTrafficLevel();
}
