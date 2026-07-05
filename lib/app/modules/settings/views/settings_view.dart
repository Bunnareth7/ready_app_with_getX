import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:learn_getx2/app/routes/app_pages.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  static void open() {
    Get.toNamed(Routes.SETTINGS);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text('Setting'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFecf0f1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.language, size: 30, color: Colors.grey),
                  SizedBox(width: 20),
                  Center(
                    child: Text('Languages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  Spacer(),
                  Text('English', style:TextStyle(color: const Color.fromARGB(255, 189, 41, 41)) ,),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFecf0f1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Log Out",
                        style: TextStyle(fontSize: 18, color: Colors.red,fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
  }
}
