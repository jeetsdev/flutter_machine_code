import '../../data/models/api_response.dart';
import '../../domain/repositories/parking_repository.dart';
import '../services/notification_service.dart';

class ParkVehicleUseCase {
  final IParkingRepository _repository;
  final NotificationService _notificationService;

  ParkVehicleUseCase(this._repository, this._notificationService);

  Future<ApiResponse<bool>> execute(int slotId, String vehicleNumber) async {
    if (vehicleNumber.isEmpty) {
      _notificationService.showNotification('Please enter a vehicle number');
      return ApiResponse.error('Vehicle number is required');
    }

    final response = _repository.parkVehicle(slotId, vehicleNumber);

    if (response.success) {
      _notificationService.showNotification(
        'Vehicle parked successfully in slot $slotId',
      );
    } else {
      _notificationService.showNotification(
        response.error ?? 'Unable to park vehicle. Slot might be occupied',
      );
    }

    return response;
  }
}
