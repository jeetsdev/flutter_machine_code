import '../entities/parking_slot.dart';
import '../entities/vehicle.dart';
import '../repositories/parking_repository.dart';

class ParkVehicleUseCase {
  final ParkingRepository repository;

  const ParkVehicleUseCase(this.repository);

  Future<ParkingResult> call(ParkVehicleParams params) async {
    try {
      // Get the parking lot to find the entry gate
      final parkingLot = await repository.getParkingLot();
      final entryGate = parkingLot.entryGates
          .firstWhere((gate) => gate.id == params.entryGateId);

      // Find the nearest available slot from the entry gate
      final slot = await repository.findNearestAvailableSlot(
        params.vehicle,
        entryGate,
      );

      if (slot == null) {
        return ParkingResult.failure('No available slot found for vehicle ${params.vehicle.licensePlate}');
      }

      // Park the vehicle
      final success = await repository.parkVehicle(params.vehicle, slot.id);

      if (success) {
        return ParkingResult.success(
          'Vehicle ${params.vehicle.licensePlate} parked successfully in slot ${slot.id}',
          slot,
        );
      } else {
        return ParkingResult.failure('Failed to park vehicle ${params.vehicle.licensePlate}');
      }
    } catch (e) {
      return ParkingResult.failure('Error parking vehicle: ${e.toString()}');
    }
  }
}

class ParkVehicleParams {
  final Vehicle vehicle;
  final String entryGateId;

  const ParkVehicleParams({
    required this.vehicle,
    required this.entryGateId,
  });
}

class ParkingResult {
  final bool isSuccess;
  final String message;
  final ParkingSlot? slot;

  const ParkingResult._({
    required this.isSuccess,
    required this.message,
    this.slot,
  });

  factory ParkingResult.success(String message, ParkingSlot slot) =>
      ParkingResult._(isSuccess: true, message: message, slot: slot);

  factory ParkingResult.failure(String message) =>
      ParkingResult._(isSuccess: false, message: message);
}
