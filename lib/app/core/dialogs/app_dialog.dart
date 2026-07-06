// lib/app/core/dialogs/app_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static void error({
    required String message,
    String title = 'Oops',
    String buttonText = 'Okay',
    Color buttonColor = Colors.blue,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      middleText: message,
      middleTextStyle: const TextStyle(fontSize: 16, color: Colors.black87),
      textConfirm: buttonText,
      confirmTextColor: Colors.white,
      buttonColor: buttonColor,
      onConfirm: Get.back,
      radius: 12,
      barrierDismissible: false,
    );
  }
}
