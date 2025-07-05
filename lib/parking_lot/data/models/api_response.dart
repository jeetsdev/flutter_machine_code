import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final dynamic data;
  final String status;
  final String message;
  final bool? error;

  ApiResponse({
    required this.data,
    required this.status,
    required this.message,
   this.error
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data =
        (json['data'] is Map<String, dynamic> || json['data'] is List<dynamic>)
            ? json['data']
            : null;

    return ApiResponse(
      data: data,
      status: json['status'] as String,
      message: json['message'] as String,
      error: (data == null || json['status'] != 'success')
    );
  }

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);

  // {
  //   return {
  //     'data': data,
  //     'status': status,
  //     'message': message,
  //   };
  // }
}
