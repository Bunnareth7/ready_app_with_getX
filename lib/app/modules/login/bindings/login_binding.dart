// lib/app/modules/login/bindings/login_binding.dart
import 'package:get/get.dart';
import 'package:learn_getx2/app/data/providers/api_service.dart';
import '../controllers/login_controller.dart';
import '../../../data/providers/api_client.dart';


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.lazyPut<LoginController>(() => LoginController());
  }
}