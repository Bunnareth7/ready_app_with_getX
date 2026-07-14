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
    return OrderTicketMessage(
      id: json['id']?.toString() ?? '',
      ticketNumber: json['ticketNumber']?.toString() ?? '',
      orderStatus: json['orderStatus']?.toString() ?? '',
      terminalId: json['terminalId']?.toString() ?? '',
    );
  }
}
