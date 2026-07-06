// lib/app/modules/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_getx2/app/core/results/result.dart';
import 'package:learn_getx2/app/data/providers/api_service.dart';

import '../../../core/dialogs/app_dialog.dart';
import '../../../core/extensions/result_extension.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Login using Result<T>
  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validate
    if (username.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter username and password';
      AppDialog.error('Please enter username and password');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // ✅ Call API - returns Result
      final result = await _apiService.login(username, password);

      // ✅ Handle Result using pattern matching
      switch (result) {
        case Success():
          // Login successful!
          final token = result.data['access_token'];
          print('✅ Token: $token');

          Get.snackbar(
            'Success',
            '✅ Login successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAllNamed('/home');
          break;

        case Failure():
         
          final error = result.message;
          final code = result.code;

          errorMessage.value = '❌ $error\n🔢 Code: ${code ?? 'N/A'}';

          // Show error dialog
          await result.showApiErrorDialog();
          break;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      AppDialog.error('Something went wrong: $e');
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
}