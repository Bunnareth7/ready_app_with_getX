import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:learn_getx2/app/data/models/order_model.dart';
import 'package:learn_getx2/app/data/providers/api_service.dart';
import 'package:learn_getx2/app/core/results/result.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final String terminalId = 'UmiMatchaTTP01Cambodia01';

  var orders = <Order>[].obs;
  var selectedTabIndex = 0.obs;
  var isLoading = false.obs;
  var tabTitles = <String>[].obs; //tabs from API

  List<Order> get filteredOrders {
    if (tabTitles.isEmpty) return [];
    if (selectedTabIndex.value == 0) {
      return orders;
    }
    final filter = tabTitles[selectedTabIndex.value];
    return orders.where((order) => order.type == filter).toList();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
  @override
  void onInit() {
    //temporary
    final storage = GetStorage();
    final token = storage.read('access_token');
    print('🔍 Token in storage: ${token != null ? 'Yes' : 'No'}');
    super.onInit();
    loadOrderTypes();
  }

  // tab titles from API
  Future<void> loadOrderTypes() async {
    try {
      final result = await _apiService.getOrderTypes();
      switch (result) {
        case Success():
          tabTitles.value = ['All', ...result.data];
          break;
        case Failure():
          tabTitles.value = [
            'All',
            'Pickup',
            'Walk-in',
            'Delivery',
            'Takeaway',
          ];
          break;
      }
    } catch (e) {
      tabTitles.value = ['All', 'Pickup', 'Walk-in', 'Delivery', 'Takeaway'];
    }
  }
}
