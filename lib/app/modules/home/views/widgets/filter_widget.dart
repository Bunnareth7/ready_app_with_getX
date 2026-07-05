// filter_widget.dart - TabBar alternative
import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xFFecf0f1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DefaultTabController(
          length: 5,
          child: TabBar(
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pickup'),
              Tab(text: 'Walk-in'),
              Tab(text: 'Delivery'),
              Tab(text: 'Takeaway'),
            ],
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
            padding: EdgeInsets.all(6),
            labelPadding: EdgeInsets.zero,
            isScrollable: false,
          ),
        ),
      ),
    );
  }
}
