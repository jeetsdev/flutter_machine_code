
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/dio_client.dart';
import '../models/api_response.dart';


extension ResponseX on Response{
  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
}

@injectable
class ParkingRemoteSource {
  late final DioClient _dioClient;

  ParkingRemoteSource(this._dioClient);

  Future<ApiResponse> getAvailableSlots() async {

    // final Uri uri = Uri.parse('${_dioClient.baseUrl}/slots/available').replace(
    //   queryParameters: {
    //     'ts': DateTime.now().millisecondsSinceEpoch.toString(),
    //   },
    // );

    // final requestBody = json.encode({
    //   'includeVip': false,
    //   'includeOccupied': false,
    // }); 
    

    // final Response response = await _dioClient.post(
    //   uri.toString(),
    //   data: requestBody,
    // );

    // if (response.isSuccess){
    //   return ApiResponse.fromJson(jsonDecode(response.data));
    // } else {
    //   throw Exception('Failed to fetch available slots: ${response.statusMessage}');
    // }

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      data: [
        {'id': 1, 'isVip': false, 'isOccupied': false},
        {'id': 2, 'isVip': false, 'isOccupied': false},
        for (var i = 3; i <= 22; i++)
          {'id': i, 'isVip': false, 'isOccupied': false},
        // In real implementation, this would be:
        // final response = await _dio.get('/slots/available');
        // return ApiResponse.fromJson(response.data);
      ],
      status: 'success',
      message: 'Available slots retrieved successfully',
    );
  }

  Future<ApiResponse> getAllSlots() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      data: [
        {'id': 1, 'isVip': false, 'isOccupied': false},
        {'id': 2, 'isVip': false, 'isOccupied': true},
        // 20 more unoccupied, non-VIP slots
        for (var i = 3; i <= 22; i++)
          {'id': i, 'isVip': false, 'isOccupied': false},
        {'id': 23, 'isVip': true, 'isOccupied': false},
      ],
      status: 'success',
      message: 'All slots retrieved successfully',
    );
  }

  Future<ApiResponse> parkVehicle(int slotId) async {
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

  Future<ApiResponse> unparkVehicle(
      String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse(
      data: {
        'ticketId': ticketId,
        'exitTime': DateTime.now().toIso8601String(),
        // 'price': 25.0,
      },
      status: 'success',
      message: 'Vehicle unparked successfully',
    );
  }

  Future<ApiResponse> getActiveTickets() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ApiResponse(
      data: [
        {
          'ticketId': 'TKT-123',
          'slotId': 1,
          'entryTime': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
        },
      ],
      status: 'success',
      message: 'Active tickets retrieved successfully',
    );
  }

  Future<ApiResponse> getTrafficLevel() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return ApiResponse(
      data: {
        'trafficLevel': 0.75,
        'occupiedSlots': 3,
        'totalSlots': 23,
      },
      status: 'success',
      message: 'Traffic level retrieved successfully',
    );
  }
}
