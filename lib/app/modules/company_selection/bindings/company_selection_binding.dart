// lib/app/modules/company_selection/bindings/company_selection_binding.dart
import 'package:get/get.dart';
import '../controllers/company_selection_controller.dart';

class CompanySelectionBinding extends Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut<CompanySelectionController>(
      () => CompanySelectionController(),
    );
  }
}