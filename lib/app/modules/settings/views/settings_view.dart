import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_getx2/app/routes/app_pages.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  static void open() {
    Get.toNamed(Routes.SETTINGS);
  }
  @override
  Widget build(BuildContext context) {
    //Check if LoginController is register, if not, register it
    if (!Get.isRegistered<LoginController>()) {
      Get.put<LoginController>(LoginController());
    }

    final LoginController loginController = Get.find<LoginController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Setting'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Language
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFecf0f1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.language, size: 30, color: Colors.grey),
                  const SizedBox(width: 20),
                  const Center(
                    child: Text(
                      'Languages',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text('English', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // LOgout
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
            child: InkWell(
              onTap: () {
                // Show confirmation dialog
                Get.defaultDialog(
                  title: 'Logout',
                  middleText: 'Are you sure you want to logout?',
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    Get.back();
                    loginController.logout(); // Call logout
                  },
                  onCancel: () {
                    Get.back();
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFecf0f1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
