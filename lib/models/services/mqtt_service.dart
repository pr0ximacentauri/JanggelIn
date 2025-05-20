import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'dart:io';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();
  
  late MqttServerClient client;
  bool _isConnected = false;

  Future<void> connect({
    required void Function(Map<String, dynamic>) onMessageReceived,
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

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      _isConnected = true;
      print('✅ Terhubung ke MQTT broker');

      client.subscribe('janggelin/sensor-dht22', MqttQos.atMostOnce);

      client.updates!.listen((events) {
        final recMess = events.first.payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        try {
          final raw = jsonDecode(payload) as Map<String, dynamic>;

          final double suhu = (raw['suhu'] as num?)?.toDouble() ?? 0;
          final double kelembaban = (raw['kelembaban'] as num?)?.toDouble() ?? 0;

          onMessageReceived({
            'temperature': suhu,
            'humidity': kelembaban,
          });
        } catch (e) {
          print('⚠️ Gagal parse MQTT payload: $e  ->  $payload');
        }
      });
    } else {
      print('❌ Status koneksi MQTT: ${client.connectionStatus}');
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