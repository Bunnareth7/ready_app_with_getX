// lib/app/modules/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:learn_getx2/app/core/results/result.dart';
import 'package:learn_getx2/app/data/providers/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
   final GetStorage _storage = GetStorage(); 

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var isPasswordVisible = false.obs;

  // Login using Result<T>
  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validate
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter username and password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // API  returns Result
      final result = await _apiService.login(username, password);

      switch (result) {
        case Success():
          final token = result.data['access_token'];
          print('✅ Token: $token');
          //success snack ba
          Get.snackbar(
            'Success',
            '✅ Login successful!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          Get.offAllNamed('/home');
          break;
        //Fail dialog
        case Failure():
          final error = result.message;

          Get.defaultDialog(
            title: 'Oops',
            titleStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            middleText: error.isNotEmpty ? error : 'Invalid credentials',
            middleTextStyle: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textConfirm: 'Okay',
            confirmTextColor: Colors.white,

            buttonColor: Colors.blue,
            onConfirm: Get.back,
            barrierDismissible: false,
            radius: 12,
          );

          break;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
   bool isLoggedIn() {
    final token = _storage.read('access_token');
    return token != null && token.isNotEmpty;
  }

  //Get token
  String? getToken() {
    return _storage.read('access_token');
  }

  //Logout
  void logout() {
    _storage.remove('access_token');
    _storage.remove('refresh_token');
    Get.offAllNamed('/login');
    Get.snackbar(
      'Logged Out',
      'You have been logged out',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
