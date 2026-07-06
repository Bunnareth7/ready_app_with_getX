// lib/app/core/dialogs/app_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  // Show error dialog
  static void error(String message) {
    Get.defaultDialog(
      title: 'Error',
      middleText: message,
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: Get.back,
      barrierDismissible: false,
    );
  }

  // Show success dialog
  static void success(String message) {
    Get.defaultDialog(
      title: 'Success',
      middleText: message,
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: Get.back,
      barrierDismissible: false,
    );
  }

  // Show custom dialog
  static void show({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
    Color? buttonColor,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: buttonText,
      confirmTextColor: Colors.white,
      buttonColor: buttonColor ?? Colors.blue,
      onConfirm: onConfirm ?? Get.back,
      barrierDismissible: false,
    );
  }

  // Show API error response
  static void apiError({
    required int? code,
    required String error,
    required String message,
  }) {
    final errorText = error.isNotEmpty ? error : message;
    Get.defaultDialog(
      title: 'Login Failed',
      middleText: '$errorText\n\nCode: ${code ?? 'N/A'}',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: Get.back,
      barrierDismissible: false,
    );
  }
}