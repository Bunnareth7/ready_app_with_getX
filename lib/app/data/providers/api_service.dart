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

  //Returns Result<T>
  Future<Result<Map<String, dynamic>>> login(
    String username,
    String password,
  ) async {
    print('📤 ===== LOGIN ATTEMPT =====');
    print('📤 Username: $username');

    try {
      final response = await _apiClient.post('/adm/v1/api/oauth2', {
        'client_id': username,
        'client_secret': password,
        'grant_type': 'client_credentials',
        'scope': 'ticket.display.integration',
      });

      final body = response.data;
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: $body');

      // ✅ Success - 200 OK
      if (response.statusCode == 200) {
        print('✅ Login successful!');
        return Success(body);
      }

      return Failure(
        code: body['code'] ?? response.statusCode,
        message: body['error'] ?? body['message'] ?? 'Login failed',
      );
    } catch (e) {
      // ✅ Network or other errors
      print('❌ Error: $e');
      return Failure(message: e.toString());
    }
  }
}
