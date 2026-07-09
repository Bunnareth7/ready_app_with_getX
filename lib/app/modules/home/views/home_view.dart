import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_getx2/app/data/models/order_model.dart';
import 'package:learn_getx2/app/data/models/food_model.dart';
import 'package:learn_getx2/app/modules/home/views/widgets/food_image_widget.dart';
import 'package:learn_getx2/app/modules/home/views/widgets/filter_widget.dart';
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
          // Store Header
          _buildHeader(),

          // Divider
          _buildDivider(),

          //const FilterWidget(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.tabTitles.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              //Use the same controller TabBar and TabBarView
              return DefaultTabController(
                length: controller.tabTitles.length,
                child: Column(
                  children: [
                    // TabBar inside the same controller
                    _buildTabBar(),
                    // TabBarView
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 40,
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
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          padding: const EdgeInsets.all(3),
          labelPadding: EdgeInsets.zero,
          isScrollable: false,
          onTap: (index) {
            controller.changeTab(index);
          },
        ),
      ),
    );
  }

  // ===== HEADER WIDGET =====
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Store location",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                "Tube Cafe 2k24",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              SettingsView.open();
            },
            child: const Icon(Icons.settings_outlined, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ===== DIVIDER WIDGET =====
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 2,
        width: double.infinity,
        color: Colors.grey.withAlpha(20),
      ),
    );
  }

  // ===== ORDER LIST FOR EACH TAB =====
  Widget _buildOrderList(String tabTitle, List<FoodModel> foods) {
    // Filter orders based on tab
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order, foods);
      },
    );
  }

  // ===== ORDER CARD WIDGET =====
  Widget _buildOrderCard(Order order, List<FoodModel> foods) {
    return Container(
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
          // Order Header
          Row(
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: order.statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: order.textColors,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Time & Location
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "${order.time} · ${order.location}",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Food Images and Order Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FoodImages(foods: foods, maxImages: 5, imageSize: 35),
              Row(
                children: [
                  Text(order.quantity),
                  const Text(" · "),
                  Text(
                    order.type,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
