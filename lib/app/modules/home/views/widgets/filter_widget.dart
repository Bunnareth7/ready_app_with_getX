import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_getx2/app/modules/home/controllers/home_controller.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return Obx(() {
      if (controller.tabTitles.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xFFecf0f1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFecf0f1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const SizedBox.shrink(),
        ),
      );
    });
  }
}
