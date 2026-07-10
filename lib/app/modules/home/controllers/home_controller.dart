import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:learn_getx2/app/data/models/order_model.dart';
import 'package:learn_getx2/app/data/providers/api_service.dart';
import 'package:learn_getx2/app/core/results/result.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final String terminalId = 'KOICXDEMO';

  var orders = <Order>[].obs;
  var selectedTabIndex = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
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
   // loadOrders();
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

  Future<void> loadOrders() async {
    if (tabTitles.isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    final filter = tabTitles[selectedTabIndex.value];

    Result<Map<String, dynamic>> result;

    if (filter == 'All') {
      // Get all orders
      result = await _apiService.getOrderList(
        terminalId: terminalId,
        page: 0,
        size: 100,
      );
    } else {
      // Get orders by type
      result = await _apiService.getOrdersByType(
        terminalId: terminalId,
        orderType: filter,
        page: 0,
        size: 100,
      );
    }

    switch (result) {
    case Success():
    final data = result.data;

    // Extract server time 
    final serverNow = data['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            data['timestamp'] as int,
            isUtc: true,
          )
        : DateTime.now().toUtc(); // fallback if timestamp is ever missing

    // Parse response - adjust based on actual API response
    final List<dynamic> orderData =
        data['data'] ?? data['list'] ?? data['tickets'] ?? [];

    orders.value = orderData
        .map((json) => Order.fromJson(json, serverNow))
        .toList();

    print('✅ Orders loaded: ${orders.length}');
    break;
      case Failure():
        errorMessage.value = result.message;
        orders.value = [];
        print('❌ ${result.message}');
        break;
    }

    isLoading.value = false;
  }

  // tab titles from API

Future<void> loadOrderTypes() async {
  try {
    final result = await _apiService.getOrderTypes();
    switch (result) {
      case Success():
        tabTitles.value = ['All', ...result.data];
        loadOrders(); 
        break;
      case Failure():
        tabTitles.value = [
          'All',
          'Pickup',
          'Walk-in',
          'Delivery',
          'Takeaway',
        ];
        loadOrders(); 
        break;
    }
  } catch (e) {
    tabTitles.value = ['All', 'Pickup', 'Walk-in', 'Delivery', 'Takeaway'];
    loadOrders(); 
  }
}
}
