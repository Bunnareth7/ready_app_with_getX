import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

// Handles MQTT connection.
class MqttService extends GetxService {
  MqttServerClient? _client;

  static const String brokerHost = '202.62.57.237';
  static const int brokerPort = 41883;
  static const String username = 'admin';
  static const String password = 'admin';

  final connectionStatus = MqttConnectionState.disconnected.obs;

  final _messageController = StreamController<MqttReceivedMessage>.broadcast();
  Stream<MqttReceivedMessage> get messages => _messageController.stream;

  Future<void> connect({required String terminalId}) async {
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      print('ℹ️ MQTT already connected — skipping reconnect');
      return;
    }

    final clientId = _buildClientId(terminalId);
    final client = MqttServerClient.withPort(brokerHost, clientId, brokerPort);
    client.keepAlivePeriod = 30;
    client.autoReconnect = true;
    client.logging(on: false);
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean();
    client.connectionMessage = connMessage;

    _client = client;

    try {
      print('📡 Connecting to MQTT as $clientId...');
      await client.connect();
    } catch (e) {
      print('❌ MQTT connect error: $e');
      client.disconnect();
      return;
    }
    var attempts = 0;
    while (client.connectionStatus?.state == MqttConnectionState.connecting &&
        attempts < 20) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('✅ MQTT connected');
      connectionStatus.value = MqttConnectionState.connected;

      client.updates.listen((events) {
        for (final event in events) {
          _messageController.add(event);
        }
      });
    } else {
      print('❌ MQTT connection failed: ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void subscribe(String topic, {MqttQos qos = MqttQos.atLeastOnce}) {
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      print('⚠️ Skipped subscribe($topic) — not connected yet');
      return;
    }
    print('📥 Subscribing: $topic');
    _client!.subscribe(topic, qos);
  }

  void publish(
    String topic,
    String message, {
    MqttQos qos = MqttQos.atLeastOnce,
  }) {
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      print('⚠️ Skipped publish($topic) — not connected yet');
      return;
    }
    final builder = MqttPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, qos, builder.payload!);
  }

  void disconnect() => _client?.disconnect();

  String _buildClientId(String terminalId) {
    final suffix = Random().nextInt(999999).toString().padLeft(6, '0');
    return 'MonakomReadyAppClient_${terminalId}_$suffix';
  }

  void _onConnected() {
    connectionStatus.value = MqttConnectionState.connected;
  }

  void _onDisconnected() {
    connectionStatus.value = MqttConnectionState.disconnected;
  }

  @override
  void onClose() {
    _messageController.close();
    disconnect();
    super.onClose();
  }
}
