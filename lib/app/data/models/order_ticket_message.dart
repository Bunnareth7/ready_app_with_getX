// lib/app/data/models/order_ticket_message.dart
//
// Fields guessed from the REST ticket shape we already parse in
// order_model.dart. Confirm/adjust once we see a real MQTT payload.
class OrderTicketMessage {
  final String id;
  final String ticketNumber;
  final String orderStatus;
  final String terminalId;

  OrderTicketMessage({
    required this.id,
    required this.ticketNumber,
    required this.orderStatus,
    required this.terminalId,
  });

  factory OrderTicketMessage.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['orderStatus']?.toString() ?? '';
    final orderStatus = rawStatus.toUpperCase() == 'PREPARING'
        ? 'READY'
        : rawStatus;

    return OrderTicketMessage(
      id: json['id']?.toString() ?? '',
      ticketNumber: json['ticketNumber']?.toString() ?? '',
      orderStatus: orderStatus,
      terminalId: json['terminalId']?.toString() ?? '',
    );
  }
}