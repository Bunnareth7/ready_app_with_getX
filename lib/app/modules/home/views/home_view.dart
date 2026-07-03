// home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_getx2/app/data/models/order_model.dart';
import 'package:learn_getx2/app/data/models/food_model.dart';
import 'package:learn_getx2/app/modules/home/views/widgets/food_image_widget.dart';
import '../controllers/home_controller.dart';
import 'widgets/filter_widget.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Order> orders = Order.dummyOrders;
    final List<FoodModel> foods = FoodModel.dummyFoods;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Header
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Store location"),
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: InkWell(
                    onTap: () {
                      //Navigator.pushNamed(context, '/settings');
                    },
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Tube Cafe 2k24",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              height: 2,
              width: double.infinity,
              color: Colors.grey.withAlpha(20),
            ),
          ),
          
          const FilterWidget(),
          
          // Order List
          ...List.generate(orders.length, (index) {
            final order = orders[index];
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Container(
                height: 115,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  border: Border.all(color: const Color(0xFFffffff)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Order ID and Status
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            order.id,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: order.statusColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.only(right: 8),
                          child: Center(
                            child: Text(
                              order.status,
                              style: TextStyle(
                                fontSize: 14,
                                color: order.textColors,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Time and Location
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.black,
                          ),
                          Text(
                            "${order.time} · ${order.location}",
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 10),
                        FoodImages(
                          foods: foods,
                          maxImages: 5,
                          imageSize: 35,
                        ),
                        const Spacer(),
                        Text(order.quantity),
                        const Text(" · "),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            order.type,
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}