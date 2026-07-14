import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

// Handles MQTT connection, matches ApiService's GetxService pattern.
class MqttService extends GetxService {
  late MqttServerClient _client;

  static const String brokerHost = '202.62.57.237';
  static const int brokerPort = 41883;
  static const String username = 'admin';
  static const String password = 'admin';

  final connectionStatus = MqttConnectionState.disconnected.obs;

  final _messageController = StreamController<MqttReceivedMessage>.broadcast();
  Stream<MqttReceivedMessage> get messages => _messageController.stream;

  Future<void> connect({required String terminalId}) async {
    final clientId = _buildClientId(terminalId);

    _client = MqttServerClient.withPort(brokerHost, clientId, brokerPort);
    _client.keepAlivePeriod = 30;
    _client.autoReconnect = true;
    _client.logging(on: false);

    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean();

    _client.connectionMessage = connMessage;

    try {
      print('📡 Connecting to MQTT as $clientId...');
      await _client.connect();
    } catch (e) {
      print('❌ MQTT connect error: $e');
      _client.disconnect();
      return;
    }

    var attempts = 0;
    while (_client.connectionStatus?.state == MqttConnectionState.connecting &&
        attempts < 20) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      print('✅ MQTT connected');
      connectionStatus.value = MqttConnectionState.connected;

      _client.updates.listen((events) {
        for (final event in events) {
          _messageController.add(event);
        }
      });
    } else {
      print('❌ MQTT connection failed: ${_client.connectionStatus}');
      _client.disconnect();
    }
  }

  void subscribe(String topic, {MqttQos qos = MqttQos.atLeastOnce}) {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      print('⚠️ Skipped subscribe($topic) — not connected yet');
      return;
    }
    print('📥 Subscribing: $topic');
    _client.subscribe(topic, qos);
  }

  void publish(
    String topic,
    String message, {
    MqttQos qos = MqttQos.atLeastOnce,
  }) {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      print('⚠️ Skipped publish($topic) — not connected yet');
      return;
    }
    final builder = MqttPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, qos, builder.payload!);
  }

  void disconnect() => _client.disconnect();

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
