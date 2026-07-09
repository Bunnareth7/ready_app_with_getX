// lib/app/modules/settings/controllers/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../login/controllers/login_controller.dart';

class SettingsController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  // Language settings
  var selectedLanguage = 'English'.obs;
  final List<String> languages = ['English', 'Khmer', 'Chinese'];
  
  // Theme settings
  var isDarkMode = false.obs;
  
  // Notification settings
  var notificationsEnabled = true.obs;




  // Load saved preferences from storage
  // void _loadPreferences() {
  //   final savedLanguage = _storage.read('language');
  //   if (savedLanguage != null) {
  //     selectedLanguage.value = savedLanguage;
  //   }
    
  //   final savedTheme = _storage.read('dark_mode');
  //   if (savedTheme != null) {
  //     isDarkMode.value = savedTheme;
  //   }
    
  //   final savedNotifications = _storage.read('notifications');
  //   if (savedNotifications != null) {
  //     notificationsEnabled.value = savedNotifications;
  //   }
  // }

  // Change language
  // void changeLanguage(String language) {
  //   selectedLanguage.value = language;
  //   _storage.write('language', language);
  //   Get.snackbar(
  //     'Language Changed',
  //     'Language set to $language',
  //     snackPosition: SnackPosition.TOP,
  //     backgroundColor: Colors.green,
  //     colorText: Colors.white,
  //   );
  // }

  // Toggle dark mode
  // void toggleDarkMode() {
  //   isDarkMode.value = !isDarkMode.value;
  //   _storage.write('dark_mode', isDarkMode.value);
  //   Get.changeThemeMode(
  //     isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
  //   );
  // }

  // Toggle notifications
  // void toggleNotifications() {
  //   notificationsEnabled.value = !notificationsEnabled.value;
  //   _storage.write('notifications', notificationsEnabled.value);
  //   Get.snackbar(
  //     'Notifications',
  //     notificationsEnabled.value 
  //         ? 'Notifications enabled' 
  //         : 'Notifications disabled',
  //     snackPosition: SnackPosition.TOP,
  //     backgroundColor: Colors.blue,
  //     colorText: Colors.white,
  //   );
  // }

  //LOGOUT METHOD
  void logout() {
    // Get the login controller
    final LoginController loginController = Get.find<LoginController>();
    
    // Show confirm
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to Logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); // Close dialog
        loginController.logout(); // call logout
      },
      onCancel: () {
        Get.back(); // Just close dialog
      },
    );
  }
}