import 'dart:math';

import '../../domain/entities/vehicle.dart';
import '../models/api_response.dart';
import '../models/parking_models.dart';

class ParkingRemoteDataSource {
  // Simulating API endpoints with Future delayed responses
  Future<ApiResponse<List<ParkingSlotModel>>> getParkingSlots() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // Simulate API response
      final response = {
        'success': true,
        'message': 'Parking slots retrieved successfully',
        'data': _generateMockParkingSlots(),
      };

      return ApiResponse.fromJson(
        response,
        (data) => (data['slots'] as List)
            .map((slot) => ParkingSlotModel.fromJson(slot))
            .toList(),
      );
    } catch (e) {
      return ApiResponse.error('Failed to get parking slots: ${e.toString()}');
    }
  }

  Future<ApiResponse<ParkingSlotModel>> findNearestSlot(
      String vehicleId, String gateId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      // Simulate API response
      final response = {
        'success': true,
        'message': 'Nearest slot found successfully',
        'data': _generateMockSlot(),
      };

      return ApiResponse.fromJson(
        response,
        (data) => ParkingSlotModel.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.error('Failed to find nearest slot: ${e.toString()}');
    }
  }

  Future<ApiResponse<bool>> parkVehicle(Vehicle vehicle, String slotId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Simulate API call
      final response = {
        'success': true,
        'message': 'Vehicle parked successfully',
        'data': {'parked': true},
      };

      return ApiResponse.fromJson(
        response,
        (data) => data['parked'] as bool,
      );
    } catch (e) {
      return ApiResponse.error('Failed to park vehicle: ${e.toString()}');
    }
  }

  Future<ApiResponse<VehicleModel>> unparkVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Simulate API response
      final response = {
        'success': true,
        'message': 'Vehicle unparked successfully',
        'data': _generateMockVehicle(),
      };

      return ApiResponse.fromJson(
        response,
        (data) => VehicleModel.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.error('Failed to unpark vehicle: ${e.toString()}');
    }
  }

  // Helper methods to generate mock data
  Map<String, dynamic> _generateMockSlot() {
    return {
      'id': 'SLOT-${Random().nextInt(100)}',
      'size': ['small', 'medium', 'large'][Random().nextInt(3)],
      'distanceFromEntrance': Random().nextDouble() * 100,
      'isOccupied': false,
    };
  }

  Map<String, dynamic> _generateMockVehicle() {
    return {
      'id': 'VEH-${Random().nextInt(100)}',
      'licensePlate': 'ABC-${Random().nextInt(1000)}',
      'size': ['small', 'medium', 'large'][Random().nextInt(3)],
    };
  }

  List<Map<String, dynamic>> _generateMockParkingSlots() {
    final slots = <Map<String, dynamic>>[];

    // Generate some mock slots for each gate
    for (final prefix in ['A', 'B', 'C']) {
      for (int i = 1; i <= 5; i++) {
        slots.add({
          'id': '$prefix-${Random().nextInt(100)}',
          'size': ['small', 'medium', 'large'][Random().nextInt(3)],
          'distanceFromEntrance': Random().nextDouble() * 100,
          'isOccupied': Random().nextBool(),
          if (Random().nextBool()) 'parkedVehicle': _generateMockVehicle(),
        });
      }
    }

    return slots;
  }
}
