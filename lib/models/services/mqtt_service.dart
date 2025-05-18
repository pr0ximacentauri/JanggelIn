import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
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
      print('❌ Koneksi MQTT gagal: $e');
      disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      _isConnected = true;
      print('✅ Connect ke MQTT broker');

      client.subscribe('janggelin/sensor-dht22', MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          onMessageReceived(data);
        } catch (e) {
          print('⚠️ Error membaca pesan MQTT: $e');
        }
      });
    } else {
      print('❌ Gagal subscribe: ${client.connectionStatus}');
      disconnect();
    }
  }

  Future<void> publishRelay({
    required int relayId, 
    required String state,
  }) async {
    if (!_isConnected) {
      debugPrint('⚠️ MQTT belum tersambung, batal publish');
      return;
    }
    final payload = jsonEncode({'relay':relayId,'state':state});
    final builder = MqttClientPayloadBuilder()..addString(payload);
    client.publishMessage(
      'janggelin/relay-control',
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: true,
    );
    debugPrint('📤 [MQTT] relay:$relayId -> $state');
  }


  void disconnect() {
    client.disconnect();
    _isConnected = false;
    print('🔌 Disconnect dari MQTT broker');
  }

  void onDisconnected() {
    _isConnected = false;
    print('⚠️ Disconnect callback terpicu');
  }
}