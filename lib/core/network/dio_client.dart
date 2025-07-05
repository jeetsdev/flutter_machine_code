import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../config/api_config.dart';



// @lazySingleton
class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  final String baseUrl;

  static const Duration connectionTimeout =
      Duration(milliseconds: ApiConfig.connectionTimeout);
  static const Duration receiveTimeout =
      Duration(milliseconds: ApiConfig.receiveTimeout);
  static const Duration sendTimeout =
      Duration(milliseconds: ApiConfig.sendTimeout);

  // Private constructor that takes baseUrl and optional interceptors
  DioClient._({
    required this.baseUrl,
    List<Interceptor>? interceptors,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectionTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add default interceptors
    _dio.interceptors.addAll([
      // Logging interceptor
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj.toString()),
      ),
      // Default error handling interceptor
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          options.queryParameters['ts'] = timestamp;
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            return handler.reject(error);
          }
          return handler.next(error);
        },
      ),
    ]);

    // Add custom interceptors if provided
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  // Factory constructor to initialize the client
  factory DioClient.initialize({
    required String baseUrl,
    List<Interceptor>? interceptors,
  }) {
    _instance = DioClient._(
      baseUrl: baseUrl,
      interceptors: interceptors,
    );
    return _instance!;
  }

  // Singleton getter - will throw if not initialized
  static DioClient get instance {
    if (_instance == null) {
      throw StateError(
        'DioClient must be initialized with DioClient.initialize() before accessing instance.',
      );
    }
    return _instance!;
  }

  // Getter for the Dio instance
  Dio get dio => _dio;

  // Utility methods for common HTTP operations
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}

class ApiMockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/comics') {
      handler.resolve(Response(
        requestOptions: options,
        // data: jsonDecode(marvelComicsApiGetComicsResponseString)
      ));
    } else {
      super.onRequest(options, handler);
    }
  }
}
