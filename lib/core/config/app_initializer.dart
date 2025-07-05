import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import 'api_config.dart';

class AppInitializer {
  static Future<void> initializeNetworking({
    List<Interceptor>? customInterceptors,
  }) async {
    // Initialize DioClient with base URL from config
    DioClient.initialize(
      baseUrl: ApiConfig.baseUrl,
      interceptors: customInterceptors,
    );
  }
}
