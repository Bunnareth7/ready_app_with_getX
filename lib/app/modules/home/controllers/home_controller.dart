import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:learn_getx2/app/data/models/order_model.dart';
import 'package:learn_getx2/app/data/providers/api_service.dart';
import 'package:learn_getx2/app/core/results/result.dart';
import 'package:learn_getx2/app/data/providers/mqtt_service.dart';
import 'package:learn_getx2/app/data/models/order_ticket_message.dart';
import 'package:mqtt5_client/mqtt5_client.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final GetStorage _storage = GetStorage();
  final MqttService _mqttService = Get.find<MqttService>();
  StreamSubscription? _mqttSubscription;

  late final String terminalId;

  var storeName = ''.obs;

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

    final storedTerminalId = _storage.read('terminalId');
    terminalId =
        (storedTerminalId != null && storedTerminalId.toString().isNotEmpty)
        ? storedTerminalId.toString()
        : 'KOICXDEMO';
    print('🔍 Using terminalId: $terminalId');

    final storedStoreName = _storage.read('storeName');
    storeName.value =
        (storedStoreName != null && storedStoreName.toString().isNotEmpty)
        ? storedStoreName.toString()
        : 'Unknown store';
    print('🔍 Using storeName: ${storeName.value}');

    super.onInit();
    loadOrderTypes();

    // Real topic, per terminal
    _ensureMqttThenSubscribe();
  }

  Future<void> _ensureMqttThenSubscribe() async {
    await _mqttService.connect(terminalId: terminalId);
    subscribeTicketReadyMQTT();
  }

  void subscribeTicketReadyMQTT() {
    print('Subscribing to MQTT topics...');
    //Listen topic per termianl
    final topic = 'TicketService_uat_TicketReadyBroadcast_$terminalId';
    _mqttService.subscribe(topic);
    _mqttSubscription = _mqttService.messages.listen((event) {
      try {
        final publishMessage = event.payload as MqttPublishMessage;
        final bytes = publishMessage.payload.message!;
        final rawStr = MqttPublishPayload.bytesToStringAsString(bytes);
        receiveMessageMQTT(event.topic ?? '', rawStr);
      } catch (e) {
        print('⚠️ Could not decode payload: $e');
      }
    });
  }

  // Mirrors lead's receiveMessageMQTT(topic, message) pattern.
  void receiveMessageMQTT(String topic, String message) {
    final decoded = jsonDecode(utf8.decode(message.codeUnits));
    print('📦 Decoded payload: $decoded');
    final receivedTicket = OrderTicketMessage.fromJson(decoded);
    _checkingTicketMessageReceived(receivedTicket);
  }

  void _checkingTicketMessageReceived(OrderTicketMessage ticket) {
    final index = orders.indexWhere((o) => o.realId == ticket.id);
    if (index != -1) {
      orders[index].orderStatus = ticket.orderStatus;
      orders.refresh();
      print('✅ Updated order ${ticket.id} in place: ${ticket.orderStatus}');
    } else {
      print('ℹ️ Unknown ticket ${ticket.id} — reloading full list');
      loadOrders();
    }
  }

  @override
  void onClose() {
    _mqttSubscription?.cancel();
    super.onClose();
  }

  // Toggles between RECALL and READY

  final Set<String> _togglingIds = {};

  Future<void> toggleOrderStatus(Order order) async {
    if (_togglingIds.contains(order.realId)) return; // already in progress
    _togglingIds.add(order.realId);

    try {
      final currentStatus = order.orderStatus.toUpperCase();
      final isReady = currentStatus == 'READY'; // only true READY can recall
      final companyId = _storage.read('company') ?? '';

      final result = isReady
          ? await _apiService.markTicketRecall(
              ticketId: order.realId,
              companyId: companyId,
              terminalId: terminalId,
            )
          : await _apiService.markTicketReady(
              ticketId: order.realId,
              companyId: companyId,
              terminalId: terminalId,
            );

      switch (result) {
        case Success():
          order.orderStatus = isReady ? 'RECALL' : 'READY';
          orders.refresh();
          break;
        case Failure():
          print('❌ Failed to update ticket: ${result.message}');
          break;
      }
    } finally {
      _togglingIds.remove(order.realId);
    }
  }

  Future<void> loadOrders() async {
    if (tabTitles.isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    final filter = tabTitles[selectedTabIndex.value];

    Result<Map<String, dynamic>> result;

    if (filter == 'All') {
      result = await _apiService.getOrderList(
        terminalId: terminalId,
        page: 0,
        size: 100,
      );
    } else {
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

        final serverNow = data['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                data['timestamp'] as int,
                isUtc: true,
              )
            : DateTime.now().toUtc();

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

  Future<void> loadOrderTypes() async {
    try {
      final result = await _apiService.getOrderTypes(terminalId: terminalId);
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
