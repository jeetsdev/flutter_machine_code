import '../entities/vehicle.dart';
import '../repositories/parking_repository.dart';

class UnparkVehicleUseCase {
  final ParkingRepository repository;

  const UnparkVehicleUseCase(this.repository);

  Future<UnparkingResult> call(String vehicleId) async {
    try {
      final vehicle = await repository.unparkVehicle(vehicleId);

      if (vehicle != null) {
        return UnparkingResult.success(
          'Vehicle ${vehicle.licensePlate} unparked successfully',
          vehicle,
        );
      } else {
        return UnparkingResult.failure('Vehicle with ID $vehicleId not found');
      }
    } catch (e) {
      return UnparkingResult.failure(
          'Error unparking vehicle: ${e.toString()}');
    }
  }
}

class UnparkingResult {
  final bool isSuccess;
  final String message;
  final Vehicle? vehicle;

  const UnparkingResult._({
    required this.isSuccess,
    required this.message,
    this.vehicle,
  });

  factory UnparkingResult.success(String message, Vehicle vehicle) =>
      UnparkingResult._(isSuccess: true, message: message, vehicle: vehicle);

  factory UnparkingResult.failure(String message) =>
      UnparkingResult._(isSuccess: false, message: message);
}
