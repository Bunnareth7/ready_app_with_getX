import 'package:get/get.dart';
import '../controllers/company_selection_controller.dart';

class CompanySelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanySelectionController>(() => CompanySelectionController());
  }
}
