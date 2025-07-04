import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/parking_slot_model.dart';

abstract class IParkingRemoteDataSource {
  Future<ApiResponse<List<ParkingSlotModel>>> getAllSlots();
  Future<ApiResponse<bool>> parkVehicle(int slotId, String vehicleNumber);
  Future<ApiResponse<bool>> unparkVehicle(int slotId);
}

class ParkingRemoteDataSource implements IParkingRemoteDataSource {
  final String baseUrl;
  final http.Client _client;

  ParkingRemoteDataSource({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<ApiResponse<List<ParkingSlotModel>>> getAllSlots() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/slots'));
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> slotsJson = json['data'];
        final slots =
            slotsJson.map((slot) => ParkingSlotModel.fromJson(slot)).toList();
        return ApiResponse.success(slots, message: json['message']);
      }
      return ApiResponse.error(json['error'] ?? 'Failed to get slots');
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<bool>> parkVehicle(
      int slotId, String vehicleNumber) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/slots/$slotId/park'),
        body: jsonEncode({'vehicleNumber': vehicleNumber}),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse.success(true, message: json['message']);
      }
      return ApiResponse.error(json['error'] ?? 'Failed to park vehicle');
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResponse<bool>> unparkVehicle(int slotId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/slots/$slotId/unpark'),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse.success(true, message: json['message']);
      }
      return ApiResponse.error(json['error'] ?? 'Failed to unpark vehicle');
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
}
