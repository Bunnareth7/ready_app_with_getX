import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ApiClient {
  late Dio _dio;
  final GetStorage _storage = GetStorage();

  static const String baseUrlGateway = 'https://uat.monakom.com/gateway/';
  static const String baseUrlApi = 'https://uat.monakom.com/216/erp_cloud/';
  static const String apiKey = '6NpyIrfdrhGGWFcoSKzydv4HprQ4qPmHq7ylz5XQ6mI';
  static const String terminalByCompany = "https://uat.monakom.com/216/erp_cloud/";

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrlGateway,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': apiKey,
        },
        validateStatus: (status) => status != null,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add token to reques
          final token = _storage.read('access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('📤 Request: ${options.method} ${options.path}');
          print('📤 Headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ Error: ${error.message}');
          if (error.response?.statusCode == 401) {
            _storage.remove('access_token');
            Get.offAllNamed('/login');
            Get.snackbar(
              'Session Expired',
              'Please login again',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  // ===== POST REQUEST =====
  Future<dynamic> post(String endpoint, dynamic data) async {
    print('📤 POST: $baseUrlGateway$endpoint');
    final response = await _dio.post(endpoint, data: data);
    return response;
  }

  // ===== GET REQUEST =====
  Future<dynamic> get(String endpoint, {String? baseUrl}) async {
    final url = baseUrl ?? baseUrlApi;
    print('📤 GET: $url$endpoint');

    //Get token from storage
    final token = _storage.read('access_token');
    print(
      '📤 Token: ${token != null ? '${token.substring(0, 20)}...' : 'No token'}',
    );

    // Add token to headers
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': apiKey,
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: url,
        headers: headers,
        validateStatus: (status) => status != null,
      ),
    );

    print('📤 Headers: $headers');

    final response = await dio.get(endpoint);
    return response;

    
  }
  
}
