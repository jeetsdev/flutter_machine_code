import 'package:test_app/features/parking_system/domain/repositories/parking_repository.dart';

class ParkingManager {
  final IParkingRepository _repository;

  ParkingManager(this._repository);

  bool parkVehicle(int slotId, String vehicleNumber) {
    if (_repository.getAvailableSlotsCount() == 0) {
      return false;
    }
    return _repository.parkVehicle(slotId, vehicleNumber);
  }

  bool unparkVehicle(int slotId) {
    return _repository.unparkVehicle(slotId);
  }

  bool isSlotAvailable(int slotId) {
    return _repository.isSlotAvailable(slotId);
  }

  int getAvailableSlotsCount() {
    return _repository.getAvailableSlotsCount();
  }

  List<dynamic> getAllSlots() {
    return _repository.getAllSlots();
  }
}
