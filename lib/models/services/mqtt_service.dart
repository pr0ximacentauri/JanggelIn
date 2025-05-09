import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:c3_ppl_agro/const.dart';
import 'dart:convert';
import 'dart:io';

class MqttService {
  late MqttServerClient client;
  bool _isConnected = false;

  Future<void> connect({
    required Function(Map<String, dynamic>) onMessageReceived,
  }) async {
    client = MqttServerClient('test.mosquitto.org', '');
    client.port = 1883;
    client.secure = false;

    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 30;
    client.onDisconnected = onDisconnected;
    client.logging(on: false);

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('❌ MQTT connection failed: $e');
      disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      _isConnected = true;
      print('✅ Connected to MQTT broker');

      client.subscribe('janggelin/sensor-dht22', MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print('📥 Received MQTT payload: $payload');

        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          onMessageReceived(data);
        } catch (e) {
          print('⚠️ Error parsing MQTT message: $e');
        }
      });
    } else {
      print('❌ Connection failed: ${client.connectionStatus}');
      disconnect();
    }
  }

  // Future<void> publish(String topic, String message) async {
  //   if (!_isConnected) {
  //     print('⚠️ MQTT not connected. Cannot publish.');
  //     return;
  //   }

  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString(message);

  //   try {
  //     client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  //     print('📤 Published to $topic: $message');
  //   } catch (e) {
  //     print('❌ Failed to publish message: $e');
  //   }
  // }

  void disconnect() {
    client.disconnect();
    _isConnected = false;
    print('🔌 Disconnected from MQTT broker');
  }

  void onDisconnected() {
    _isConnected = false;
    print('⚠️ Disconnected callback triggered');
  }
}