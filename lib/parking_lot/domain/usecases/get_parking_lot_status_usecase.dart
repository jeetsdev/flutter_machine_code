import '../entities/parking_lot.dart';
import '../repositories/parking_repository.dart';

class GetParkingLotStatusUseCase {
  final ParkingRepository repository;

  const GetParkingLotStatusUseCase(this.repository);

  Future<ParkingLotStatusResult> call() async {
    try {
      final parkingLot = await repository.getParkingLot();
      final status = await repository.getParkingLotStatus();

      return ParkingLotStatusResult.success(parkingLot, status);
    } catch (e) {
      return ParkingLotStatusResult.failure(
          'Error getting parking lot status: ${e.toString()}');
    }
  }
}

class ParkingLotStatusResult {
  final bool isSuccess;
  final String? errorMessage;
  final ParkingLot? parkingLot;
  final Map<String, dynamic>? status;

  const ParkingLotStatusResult._({
    required this.isSuccess,
    this.errorMessage,
    this.parkingLot,
    this.status,
  });

  factory ParkingLotStatusResult.success(
          ParkingLot parkingLot, Map<String, dynamic> status) =>
      ParkingLotStatusResult._(
        isSuccess: true,
        parkingLot: parkingLot,
        status: status,
      );

  factory ParkingLotStatusResult.failure(String errorMessage) =>
      ParkingLotStatusResult._(
        isSuccess: false,
        errorMessage: errorMessage,
      );
}
