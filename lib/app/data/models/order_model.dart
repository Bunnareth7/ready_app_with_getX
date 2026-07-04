import 'package:flutter/material.dart';

class Order {
  final String id;
  final String time;
  final String location;
  final String status;
  final Color statusColor;
  final String quantity;
  final String type;
  final Color textColors;

  Order({
    required this.id,
    required this.time,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.quantity,
    required this.type,
    required this.textColors
    
  });

  static List<Order> get dummyOrders => [
    Order(
      id: '001-123',
      time: '1h 25m',
      location: 'Counter',
      status: 'Ready',
      statusColor: Color(0xFFe3f5e3),
      quantity: 'X7 ',
      type: 'Pickup',
      textColors: Color(0xFF0BB20B)
    ),
    Order(
      id: 'CHHUNDARA KHORN',
      time: '1h 25m',
      location: 'Mobile',
      status: 'Re-call',
      statusColor: const Color(0xFFfdf1d7),
      quantity: 'X7 ',
      type: 'Pickup',
      textColors: Color(0xFFF1BD00)
    ),
    Order(
      id: 'K12',
      time: '1h 25m',
      location: 'KIOSK',
      status: 'Ready',
      statusColor: Color(0xFFe3f5e3),
      quantity: 'X7 ',
      type: 'Dine in',
      textColors: Color(0xFF0BB20B)
    ),
    Order(
      id: 'G-123',
      time: '1h 25m',
      location: 'Grab',
      status: 'Re-call',
      statusColor: const Color(0xFFfdf1d7),
      quantity: 'X7 ',
      type: 'Delivery',
      textColors: Color(0xFFF1BD00)
    ),
  ];
}