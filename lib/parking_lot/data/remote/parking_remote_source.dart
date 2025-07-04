import 'package:dio/dio.dart';

import '../models/api_response.dart';

class ParkingRemoteSource {
  final Dio _dio;
  final String _baseUrl = 'https://api.parking.example.com'; // dummy base URL

  ParkingRemoteSource({Dio? dio}) : _dio = dio ?? Dio();

  Future<ApiResponse<List<Map<String, dynamic>>>> getAvailableSlots() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse(
      data: [
        {'id': 1, 'size': 'SMALL', 'type': 'REGULAR', 'isOccupied': false},
        {'id': 2, 'size': 'MEDIUM', 'type': 'REGULAR', 'isOccupied': false},
        {'id': 3, 'size': 'LARGE', 'type': 'REGULAR', 'isOccupied': false},
        {'id': 4, 'size': 'LARGE', 'type': 'VIP', 'isOccupied': false},
        {'id': 5, 'size': 'MEDIUM', 'type': 'HANDICAPPED', 'isOccupied': false},
      ],
      status: 'success',
      message: 'Available slots retrieved successfully',
    );
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getAllSlots() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      data: [
        {
          'id': 1,
          'size': 'small',
          'type': 'regular',
          'isOccupied': false,
        },
        {
          'id': 2,
          'size': 'medium',
          'type': 'regular',
          'isOccupied': true,
          'occupiedBy': 'ABC123',
        },
        {
          'id': 3,
          'size': 'large',
          'type': 'regular',
          'isOccupied': false,
        },
        {
          'id': 51,
          'size': 'medium',
          'type': 'vip',
          'isOccupied': false,
        },
        {
          'id': 52,
          'size': 'large',
          'type': 'handicapped',
          'isOccupied': false,
        },
      ],
      status: 'success',
      message: 'All slots retrieved successfully',
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> parkVehicle(int slotId,
      String licensePlate, String vehicleSize, String vehicleType) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final currentTime = DateTime.now();
    return ApiResponse(
      data: {
        'id': 'TKT-${currentTime.millisecondsSinceEpoch}',
        'licensePlate': licensePlate,
        'slotId': slotId,
        'entryTime': currentTime.toIso8601String(),
        'vehicleSize': vehicleSize,
        'vehicleType': vehicleType,
        'exitTime': null,
        'price': null
      },
      status: 'success',
      message: 'Vehicle parked successfully',
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> unparkVehicle(
      String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final exitTime = DateTime.now();
    return ApiResponse(
      data: {
        'id': ticketId,
        'licensePlate': 'ABC123', // Using mock data since we don't store state
        'slotId': 1, // Using mock data since we don't store state
        'entryTime': exitTime
            .subtract(const Duration(hours: 2))
            .toIso8601String(), // Mock 2 hour parking duration
        'vehicleSize': 'MEDIUM', // Using mock data since we don't store state
        'vehicleType': 'REGULAR', // Using mock data since we don't store state
        'exitTime': exitTime.toIso8601String(),
        'price': 1000
      },
      status: 'success',
      message: 'Vehicle unparked successfully',
    );
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getActiveTickets() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return ApiResponse(
      data: [
        {
          'id': 'TKT-1',
          'licensePlate': 'ABC123',
          'slotId': 1,
          'entryTime': now.subtract(const Duration(hours: 1)).toIso8601String(),
          'vehicleSize': 'SMALL',
          'vehicleType': 'REGULAR',
          'exitTime': null,
          'price': null
        },
        {
          'id': 'TKT-2',
          'licensePlate': 'XYZ789',
          'slotId': 2,
          'entryTime': now.subtract(const Duration(hours: 2)).toIso8601String(),
          'vehicleSize': 'LARGE',
          'vehicleType': 'VIP',
          'exitTime': null,
          'price': null
        },
        {
          'id': 'TKT-3',
          'licensePlate': 'DEF456',
          'slotId': 5,
          'entryTime':
              now.subtract(const Duration(minutes: 30)).toIso8601String(),
          'vehicleSize': 'MEDIUM',
          'vehicleType': 'HANDICAPPED',
          'exitTime': null,
          'price': null
        }
      ],
      status: 'success',
      message: 'Active tickets retrieved successfully',
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getTrafficLevel() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return ApiResponse(
      data: {
        'trafficLevel': 0.75,
        'occupiedSlots': 45,
        'totalSlots': 60,
      },
      status: 'success',
      message: 'Traffic level retrieved successfully',
    );
  }
}
