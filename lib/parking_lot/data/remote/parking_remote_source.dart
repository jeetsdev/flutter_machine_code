import 'package:dio/dio.dart';
import '../models/api_response.dart';

class ParkingRemoteSource {
  final Dio _dio;
  final String _baseUrl = 'https://api.parking.example.com'; // dummy base URL

  ParkingRemoteSource({Dio? dio}) : _dio = dio ?? Dio();

  Future<ApiResponse<List<Map<String, dynamic>>>> getAvailableSlots() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      data: [
        {'id': 1, 'isVip': false, 'isOccupied': false},
        {'id': 2, 'isVip': false, 'isOccupied': false},
        // In real implementation, this would be:
        // final response = await _dio.get('\$_baseUrl/slots/available');
        // return ApiResponse.fromJson(response.data);
      ],
      status: 'success',
      message: 'Available slots retrieved successfully',
    );
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getAllSlots() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      data: [
        {'id': 1, 'isVip': false, 'isOccupied': false},
        {'id': 2, 'isVip': false, 'isOccupied': true},
        {'id': 51, 'isVip': true, 'isOccupied': false},
      ],
      status: 'success',
      message: 'All slots retrieved successfully',
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> parkVehicle(int slotId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse(
      data: {
        'ticketId': 'TKT-${DateTime.now().millisecondsSinceEpoch}',
        'slotId': slotId,
        'entryTime': DateTime.now().toIso8601String(),
      },
      status: 'success',
      message: 'Vehicle parked successfully',
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> unparkVehicle(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse(
      data: {
        'ticketId': ticketId,
        'exitTime': DateTime.now().toIso8601String(),
        'price': 25.0,
      },
      status: 'success',
      message: 'Vehicle unparked successfully',
    );
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getActiveTickets() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      data: [
        {
          'ticketId': 'TKT-123',
          'slotId': 1,
          'entryTime': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        },
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
