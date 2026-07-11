import 'package:get/get.dart';
import 'package:learn_getx2/app/core/results/result.dart';
import '../providers/api_client.dart';

class ApiService extends GetxService {
  late ApiClient _apiClient;

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
  Future<Result<List<String>>> getOrderTypes({
    required String terminalId,
  }) async {
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

  // ===== GET CURRENT USER =====

  Future<Result<Map<String, dynamic>>> getCurrentUser() async {
    try {
      print('📤 Getting current user...');

      final response = await _apiClient.get(
        'adm/v1/api/user/info',
        baseUrl: ApiClient.baseUrlApi,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Full Response: ${response.data}');
      print('📥 Response Type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final dynamic data = response.data;
        if (data is Map<String, dynamic>) {
          return Success(data);
        }
        return Failure(
          message: 'Unexpected response format: ${data.runtimeType}',
        );
      }

      return Failure(
        message: response.data['message'] ?? 'Failed to get current user',
      );
    } catch (e) {
      print('❌ Error getting current user: $e');
      return Failure(message: e.toString());
    }
  }

  String? _extractUserId(Map<String, dynamic> userInfo) {
    for (final key in ['id', 'userId', 'uuid', 'user_id']) {
      final value = userInfo[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    // Some APIs nest it, e.g. {"data": {"id": "..."}}
    final nested = userInfo['data'];
    if (nested is Map<String, dynamic>) {
      return _extractUserId(nested);
    }
    return null;
  }

  // ===== GET COMPANIES =====

  Future<Result<Map<String, dynamic>>> getCompanies() async {
    try {
      print('📤 Getting current user (for ID)...');
      final userResult = await getCurrentUser();

      if (userResult.isFailure) {
        return Failure(
          message:
              'Could not resolve user ID before fetching companies: '
              '${userResult.error}',
        );
      }

      final userInfo = userResult.data!;
      final userId = _extractUserId(userInfo);

      if (userId == null) {
        print('❌ Could not find a user ID field in: $userInfo');
        return Failure(message: 'User ID not found in /user/info response');
      }

      print('📤 Getting companies for user: $userId');

      final response = await _apiClient.get(
        'adm/v1/api/user/user-company/$userId',
        baseUrl: ApiClient.baseUrlApi,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Full Response: ${response.data}');
      print('📥 Response Type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final dynamic data = response.data;
        if (data is Map<String, dynamic>) {
          return Success(data);
        }
        if (data is List) {
          return Success({'data': data});
        }
        return Failure(
          message: 'Unexpected response format: ${data.runtimeType}',
        );
      }

      return Failure(
        message: response.data['message'] ?? 'Failed to get companies',
      );
    } catch (e) {
      print('❌ Error getting companies: $e');
      return Failure(message: e.toString());
    }
  }
  // ===== GET TERMINALS =====
  Future<Result<Map<String, dynamic>>> getTerminals(String company) async {
    try {
      print('📤 Getting current user (for ID)...');
      final userResult = await getCurrentUser();

      if (userResult.isFailure) {
        return Failure(
          message:
              'Could not resolve user ID before fetching terminals: '
              '${userResult.error}',
        );
      }
      final userInfo = userResult.data!;
      final userId = _extractUserId(userInfo);

      if (userId == null) {
        print('❌ Could not find a user ID field in: $userInfo');
        return Failure(message: 'User ID not found in /user/info response');
      }

      print('📤 Getting terminals for user: $userId, company: $company');

      final response = await _apiClient.get(
        'adm/v1/api/user/user-td-terminal/$userId?companyCode=$company',
        baseUrl: ApiClient.baseUrlApi,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Full Response: ${response.data}');
      print('📥 Response Type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final dynamic data = response.data;
        if (data is Map<String, dynamic>) {
          return Success(data);
        }
        if (data is List) {
          return Success({'data': data});
        }
        return Failure(
          message: 'Unexpected response format: ${data.runtimeType}',
        );
      }

      return Failure(
        message: response.data['message'] ?? 'Failed to get terminals',
      );
    } catch (e) {
      print('❌ Error getting terminals: $e');
      return Failure(message: e.toString());
    }
  }
}
