class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(
      success: false,
      message: message,
    );
  }
}
