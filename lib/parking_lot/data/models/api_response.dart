class ApiResponse<T> {
  final T data;
  final String status;
  final String message;

  ApiResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return ApiResponse(
      data: fromJson(json['data']),
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    return {
      'data': toJson(data),
      'status': status,
      'message': message,
    };
  }
}
