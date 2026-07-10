import 'package:get/get.dart';
import 'package:learn_getx2/app/core/results/result.dart';
import '../providers/api_client.dart';

class ApiService extends GetxService {
  late ApiClient _apiClient;
  final String terminalId = 'KOICXDEMO';

  @override
  void onInit() {
    super.onInit();
    _apiClient = Get.find<ApiClient>();
  }
  //LOGIN
  Future<Result<Map<String, dynamic>>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _apiClient.post('/adm/v1/api/oauth2', {
        'client_id': username,
        'client_secret': password,
        'grant_type': 'client_credentials',
        'scope': 'ticket.display.integration',
      });

      final body = response.data;

      if (response.statusCode == 200) {
        return Success(body);
      }
      return Failure(
        code: body['code'] ?? response.statusCode,
        message: body['error'] ?? body['message'] ?? 'Login failed',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  //GET ORDER TYPES
  Future<Result<List<String>>> getOrderTypes() async {
    try {
      print('📤 Getting order types...');

      final response = await _apiClient.get(
        'adm/v1/api/queue_display/tickets/order-type?terminalId=$terminalId',
        baseUrl: ApiClient.baseUrlGateway,
      );

      print('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        List<String> types = [];
        if (data is List) {
          types = data.map((e) => e.toString()).toList();
        } else if (data.containsKey('types')) {
          types = List<String>.from(data['types']);
        } else if (data.containsKey('data')) {
          types = List<String>.from(data['data']);
        }
        return Success(types);
      }

      return Failure(
        message: response.data['message'] ?? 'Failed to get order types',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  //GET ORDER LIST 
  Future<Result<Map<String, dynamic>>> getOrderList({
    required String terminalId,
    int page = 0,
    int size = 100,
  }) async {
    try {
      print('📤 Getting order list...');
      print('📤 Terminal ID: $terminalId');

      final endpoint =
          'adm/v1/api/queue_display/tickets/list?page=$page&size=$size&terminalId=$terminalId';

      final response = await _apiClient.get(
        endpoint,
        baseUrl: ApiClient.baseUrlGateway,
      );

      print('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Success(response.data);
      }

      return Failure(
        message: response.data['message'] ?? 'Failed to get order list',
      );
    } catch (e) {
      print('❌ Error: $e');
      return Failure(message: e.toString());
    }
  }

  //GET ORDERS BY TYPE
  Future<Result<Map<String, dynamic>>> getOrdersByType({
    required String terminalId,
    required String orderType,
    int page = 0,
    int size = 100,
  }) async {
    try {
      print('📤 Getting orders for: $orderType');
      print('📤 Terminal ID: $terminalId');

      final endpoint =
          'adm/v1/api/queue_display/tickets/list?page=$page&size=$size&terminalId=$terminalId&orderType=$orderType';

      final response = await _apiClient.get(
        endpoint,
        baseUrl: ApiClient.baseUrlGateway,
      );

      print('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Success(response.data);
      }

      return Failure(
        message:
            response.data['message'] ?? 'Failed to get orders for $orderType',
      );
    } catch (e) {
      print('❌ Error: $e');
      return Failure(message: e.toString());
    }
  }
}
