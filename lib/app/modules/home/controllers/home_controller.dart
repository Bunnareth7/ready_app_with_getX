// home_controller.dart
import 'package:get/get.dart';
import 'package:learn_getx2/app/data/models/order_model.dart';


class HomeController extends GetxController {
  var orders = <Order>[].obs;
  var selectedTabIndex = 0.obs;
  final List<String> tabTitles = ['All', 'Pickup', 'Walk-in', 'Delivery', 'Takeaway'];
  
  List<Order> get filteredOrders {
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
    super.onInit();
    orders.value = Order.dummyOrders;
  }
}