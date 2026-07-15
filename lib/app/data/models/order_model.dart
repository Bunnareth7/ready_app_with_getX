// lib/app/data/models/order_model.dart

import 'package:flutter/material.dart';

class Order {
  final String id;
  final String type;
  final String status;
  final String time;
  final String location;
  final String quantity;
  final String description;
  final String createdAt;
  final String ticketNumber;
  final String destinationName;
  final String terminalCode;
  final String invoiceNo;
  final bool rawStatus;
  String orderStatus; // real backend status: RECALL or READY
  final String realId; // actual UUID from the API — needed for status updates
  final DateTime? createdAtUtc; // parsed creation time, for live recalculation
  final Duration serverOffset; // server clock vs device clock, at load time

  Order({
    required this.id,
    required this.type,
    required this.status,
    required this.time,
    required this.location,
    required this.quantity,
    required this.description,
    required this.createdAt,
    required this.ticketNumber,
    required this.destinationName,
    required this.terminalCode,
    required this.invoiceNo,
    required this.rawStatus,
    required this.orderStatus,
    required this.realId,
    required this.createdAtUtc,
    required this.serverOffset,
  });

  // ✅ Parse from API response
  // NOTE: `serverNow` must come from the API response's top-level `timestamp`
  // field (epoch millis, UTC). This ensures every terminal calculates
  // elapsed time against the SAME clock, instead of each device's own
  // (possibly wrong / different-timezone) local clock.
  factory Order.fromJson(Map<String, dynamic> json, DateTime serverNow) {
    print('📥 Parsing Order: $json');

    // ✅ Ticket Number - format as 2 digits
    final ticketNum = _safeString(json['ticketNumber']) ??
        _safeString(json['id']) ??
        '';
    final formattedId = _formatOrderNumber(ticketNum);

    // ✅ Order Type
    final type = _safeString(json['orderType']) ??
        _safeString(json['destinationName']) ??
        'DineIn';

    // ✅ Status - convert boolean to string
    final rawStatus = json['status'] ?? false;
    final status = rawStatus == true ? 'Ready' : 'Pending';
    final rawOrderStatus = _safeString(json['orderStatus']) ?? 'READY';
    final orderStatus = rawOrderStatus.toUpperCase() == 'PREPARING'
        ? 'READY'
        : rawOrderStatus;

    // ✅ Time - parse timeoutTime or dateCreated
    final rawTime = _safeString(json['dateCreated']) ?? '';
    final formattedTime = _formatWaitingTime(rawTime, serverNow);

    // For live-updating elapsed time later (see liveElapsedTime getter).
    final createdAtUtc = _parseToUtc(rawTime);
    final serverOffset = serverNow.difference(DateTime.now().toUtc());

    // ✅ Location - destinationName
    final location = _safeString(json['destinationName']) ??
        _safeString(json['terminalCode']) ??
        'MONAKOMQROrdering';

    // ✅ Quantity - totalQty
    final quantity = _safeString(json['totalQty']) ?? '1';

    // ✅ Description - invoiceNo or refNumber
    final description = _safeString(json['invoiceNo']) ??
        _safeString(json['refNumber']) ??
        '';

    // ✅ Created At
    final createdAt = _safeString(json['dateCreated']) ?? '';

    return Order(
      id: formattedId,
      type: type,
      status: status,
      time: formattedTime,
      location: location,
      quantity: quantity,
      description: description,
      createdAt: createdAt,
      ticketNumber: ticketNum,
      destinationName: _safeString(json['destinationName']) ?? '',
      terminalCode: _safeString(json['terminalCode']) ?? '',
      invoiceNo: _safeString(json['invoiceNo']) ?? '',
      rawStatus: rawStatus,
      orderStatus: orderStatus,
      realId: _safeString(json['id']) ?? '',
      createdAtUtc: createdAtUtc,
      serverOffset: serverOffset,
    );
  }

  // ✅ Format order number: "70", "71", "72"
  static String _formatOrderNumber(String id) {
    if (id.isEmpty) return '00';

    // If it's a number, pad with zeros
    if (int.tryParse(id) != null) {
      return id.padLeft(2, '0');
    }

    // If it's a UUID, extract last 2 digits
    if (id.contains('-')) {
      final parts = id.split('-');
      final last = parts.last;
      if (last.length >= 2) {
        return last.substring(last.length - 2);
      }
      return last.padLeft(2, '0');
    }

    // If it's a long string, take last 2 characters
    if (id.length > 2) {
      return id.substring(id.length - 2);
    }

    return id.padLeft(2, '0');
  }

  // Recalculates elapsed time fresh every time it's read, instead of the
  // frozen `time` string from when the order was first loaded. Call
  // orders.refresh() periodically (see HomeController) to make widgets
  // showing this actually re-render and tick forward.
  String get liveElapsedTime {
    if (createdAtUtc == null) return time; // fallback if we couldn't parse a real datetime
    final estimatedServerNow = DateTime.now().toUtc().add(serverOffset);
    final difference = estimatedServerNow.difference(createdAtUtc!);
    return _formatDuration(difference);
  }

  static String _formatDuration(Duration difference) {
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    final totalMinutes = difference.inMinutes;
    return totalMinutes < 0 ? '0m' : '${totalMinutes}m';
  }

  // Parses dateCreated into a real UTC DateTime, or null if it's already
  // a formatted string ("28m") or plain number — those can't be recalculated.
  static DateTime? _parseToUtc(String timeStr) {
    if (timeStr.isEmpty) return null;
    if (timeStr.contains('m') || timeStr.contains('h')) return null;
    String normalized = timeStr;
    if (!normalized.endsWith('Z') && !normalized.contains('+')) {
      normalized = '${normalized}Z';
    }
    return DateTime.tryParse(normalized);
  }

  // ✅ Format waiting time: "28m", "1h 42m"
  // `serverNow` is the server's clock (from the API response's `timestamp`
  // field), NOT DateTime.now(). This avoids drift/mismatch between
  // terminals that have different device clocks or timezone settings.
  static String _formatWaitingTime(String timeStr, DateTime serverNow) {
    if (timeStr.isEmpty) return '0m';

    try {
      // If it's already formatted like "28m" or "1h 42m", return as is
      if (timeStr.contains('m') || timeStr.contains('h')) {
        return timeStr;
      }

      // dateCreated comes with no timezone suffix, e.g. "2024-03-15T11:18:37"
      // Force it to be parsed as UTC so it aligns with serverNow (also UTC).
      //
      // ⚠️ IMPORTANT: confirm with your backend whether `dateCreated` is
      // actually UTC or Cambodia local time (UTC+7). If it's local time,
      // see the alternate block commented below instead.
      String normalized = timeStr;
      if (!normalized.endsWith('Z') && !normalized.contains('+')) {
        normalized = '${normalized}Z';
      }

      final dateTime = DateTime.tryParse(normalized);
      if (dateTime != null) {
        final difference = serverNow.difference(dateTime);

        final hours = difference.inHours;
        final minutes = difference.inMinutes.remainder(60);

        if (hours > 0) {
          if (minutes > 0) {
            return '${hours}h ${minutes}m';
          } else {
            return '${hours}h';
          }
        } else {
          final totalMinutes = difference.inMinutes;
          return '${totalMinutes}m';
        }
      }

      final minutes = int.tryParse(timeStr);
      if (minutes != null) {
        if (minutes >= 60) {
          final hours = minutes ~/ 60;
          final remainingMinutes = minutes % 60;
          if (remainingMinutes > 0) {
            return '${hours}h ${remainingMinutes}m';
          }
          return '${hours}h';
        }
        return '${minutes}m';
      }
    } catch (e) {
      print('⚠️ Error formatting time: $e');
    }

    return '0m';
  }

  static String? _safeString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    return value.toString();
  }

  // ✅ Status color based on status
  Color get statusColor {
    final s = orderStatus.toLowerCase();
    if (s == 'ready') return Color(0xFF0BB20B);
    if (s == 'recall') return Color(0xFFF1BD00);
    return Colors.grey;
  }

  // ✅ Text color for status badge — always white regardless of status
  Color get textColors => Colors.white;
}