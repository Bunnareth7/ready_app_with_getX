import 'package:get/get.dart';
import 'package:learn_getx2/app/core/results/result.dart';
import '../providers/api_client.dart';

class ApiService extends GetxService {
  late ApiClient _apiClient;

  final String terminalId = 'UmiMatchaTTP01Cambodia01';

  @override
  void onInit() {
    super.onInit();
    _apiClient = Get.find<ApiClient>();
  }

  // LOGIN

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

      if (response.statusCode == 200) {
        return Success(response.data);
      }

      return Failure(
        code: response.data['code'],
        message: response.data['message'] ?? 'Login failed',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  // GET ORDER TYPES

  Future<Result<List<String>>> getOrderTypes() async {
    try {
      print('📤 Getting order types...');

      final response = await _apiClient.get(
        'adm/v1/api/queue_display/tickets/order-type?terminalId=$terminalId',
        baseUrl: ApiClient.baseUrlGateway,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        List<String> types = [];

        if (data is List) {
          types = data.map((e) => e.toString()).toList();
        } else if (data['data'] is List) {
          types = List<String>.from(data['data']);
        } else if (data['types'] is List) {
          types = List<String>.from(data['types']);
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

  // GET ORDERS BY TYPE

  Future<Result<Map<String, dynamic>>> getOrdersByType({
    required String orderType,
  }) async {
    try {
      print('📤 Getting orders...');

      final response = await _apiClient.get(
        'adm/v1/api/queue_display/tickets/order-type?terminalId=$terminalId&orderType=$orderType',
        baseUrl: ApiClient.baseUrlApi,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.data}');

      if (response.statusCode == 200) {
        return Success(response.data);
      }

      return Failure(
        message: response.data['message'] ?? 'Failed to get orders',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  // GET ORDER LIST

  Future<Result<Map<String, dynamic>>> getOrderList() async {
    try {
      print('📤 Getting order list...');

      final response = await _apiClient.get(
        'adm/v1/api/queue_display/tickets/list?terminalId=$terminalId',
        baseUrl: ApiClient.baseUrlApi,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.data}');

      if (response.statusCode == 200) {
        return Success(response.data);
      }

      return Failure(
        message: response.data['message'] ?? 'Failed to get order list',
      );
    } catch (e) {
      return Failure(message: e.toString());
    }
  }
}
