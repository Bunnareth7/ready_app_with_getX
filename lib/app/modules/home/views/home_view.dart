// lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_getx2/app/data/models/order_model.dart';
import 'package:learn_getx2/app/data/models/food_model.dart';

import 'package:learn_getx2/app/modules/settings/views/settings_view.dart';
import 'package:learn_getx2/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static void open() {
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodModel> foods = FoodModel.dummyFoods;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildDivider(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.tabTitles.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              //rebuild when tabs change
              return DefaultTabController(
                key: ValueKey(controller.tabTitles.length),
                length: controller.tabTitles.length,
                child: Column(
                  children: [
                    _buildTabBar(),
                    Expanded(
                      child: TabBarView(
                        children: controller.tabTitles.map((tabTitle) {
                          return _buildOrderList(tabTitle, foods);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===== TAB BAR =====
  Widget _buildTabBar() {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,),
      child: Container(
        height: 30,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFecf0f1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TabBar(
          tabs: controller.tabTitles.map((title) {
           
            return Tab(text: title);
          }).toList(),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 14,
          ), 
          isScrollable: true, 
          tabAlignment: TabAlignment.start,
          onTap: (index) {
            // Call changeTab method
            controller.changeTab(index);
          },
        ),
      ),
    );
  }

  // ===== HEADER WIDGET =====
  Widget _buildHeader() {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Store location",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(//Store name by terminal
                  controller.storeName.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () => controller.loadOrders(),
                child: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.refresh, color: Colors.black54),
                ),
              ),
              InkWell(
                onTap: () {
                  SettingsView.open();
                },
                child: const Icon(Icons.settings_outlined, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== DIVIDER WIDGET =====
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(top:  10, bottom: 10),
      child: Container(
        height: 2,
        width: double.infinity,
        color: Colors.white.withAlpha(10),
      ),
    );
  }

  // ===== ORDER LIST FOR EACH TAB =====
  Widget _buildOrderList(String tabTitle, List<FoodModel> foods) {
    List<Order> filteredOrders;
    if (tabTitle == 'All') {
      filteredOrders = controller.orders;
    } else {
      filteredOrders = controller.orders
          .where((order) => order.type == tabTitle)
          .toList();
    }

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No $tabTitle orders',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => Get.find<HomeController>().loadOrders(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return _buildOrderCard(order, foods);
        },
      ),
    );
  }

  // ===== ORDER CARD WIDGET =====
  Widget _buildOrderCard(Order order, List<FoodModel> foods) {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Order Number
                    Text(
                      _formatOrderNumber(order.id),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${order.time} · ${order.location}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //BUTTON STATUS
              GestureDetector(
                onTap: () => Get.find<HomeController>().toggleOrderStatus(order),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: order.statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.displayStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: order.textColors,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Spacer(),
              Text(
                'x${order.quantity} · ${order.type}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====Format Order Number =====
  String _formatOrderNumber(String id) {
    if (int.tryParse(id) != null) {
      return id.padLeft(2, '0');
    }
    if (id.contains('-')) {
      final parts = id.split('-');
      final last = parts.last;
      if (last.length >= 2) {
        return last.substring(last.length - 2);
      }
      return last;
    }
    if (id.length > 2) {
      return id.substring(id.length - 2);
    }
    return id.padLeft(2, '0');
  }
}