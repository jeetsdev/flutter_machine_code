import '../../data/models/api_response.dart';
import '../../domain/repositories/parking_repository.dart';
import '../services/notification_service.dart';

class UnparkVehicleUseCase {
  final IParkingRepository _repository;
  final NotificationService _notificationService;

  UnparkVehicleUseCase(this._repository, this._notificationService);

  Future<ApiResponse<bool>> execute(int slotId) async {
    final response = _repository.unparkVehicle(slotId);

    if (response.success) {
      _notificationService.showNotification(
        'Vehicle unparked successfully from slot $slotId',
      );
    } else {
      _notificationService.showNotification(
        response.error ?? 'Unable to unpark vehicle. Slot might be empty',
      );
    }

    return response;
  }
}
