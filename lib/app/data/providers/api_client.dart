import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;

  // Base URL
  static const String baseUrl = 'https://uat.monakom.com/gateway/';
  static const String apiKey = '6NpyIrfdrhGGWFcoSKzydv4HprQ4qPmHq7ylz5XQ6mI';

  // Constructor
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': apiKey,
        },
        // Accept all status codes
        validateStatus: (status) => status != null,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // POST request
  Future<dynamic> post(String endpoint, dynamic data) async {
    print('📤 POST: $baseUrl$endpoint');
    final response = await _dio.post(endpoint, data: data);
    return response;
  }
}
