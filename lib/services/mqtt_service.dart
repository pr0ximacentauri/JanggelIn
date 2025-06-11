import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import '../const.dart';
import 'dart:io';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();

  late MqttServerClient _client;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect({
    required void Function(Map<String, dynamic>) onSensorMessage,
    required void Function(Map<String, dynamic>) onControlStatusChanged,
  }) async {
    _client = MqttServerClient('${AppConfig.mqttBroker}', '');
    _client.port = 1883;
    _client.secure = false;

    _client.securityContext = SecurityContext.defaultContext;
    _client.keepAlivePeriod = 30;
    _client.onDisconnected = onDisconnected;
    _client.logging(on: false);

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } catch (e) {
      print('❌ Koneksi MQTT gagal: $e');
      disconnect();
      return;
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _isConnected = true;
      print('✅ Terhubung ke MQTT broker');

      _client.subscribe('${AppConfig.mqttTopicSub}', MqttQos.atMostOnce);
      _client.subscribe('${AppConfig.mqttTopicSub2}', MqttQos.atLeastOnce);

      _client.updates!.listen((events) {
        final topic = events.first.topic;
        final recMess = events.first.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;

          if (topic == '${AppConfig.mqttTopicSub}') {
            final double suhu = (data['suhu'] as num?)?.toDouble() ?? 0;
            final double kelembapan = (data['kelembapan'] as num?)?.toDouble() ?? 0;
            onSensorMessage({
              'temperature': suhu,
              'humidity': kelembapan,
            });
          }  
          if (topic == '${AppConfig.mqttTopicSub2}') {
            final int id = data['id_kontrol'] as int;
            final String status = data['status'] as String;
            onControlStatusChanged({
              'id_kontrol': id,
              'status': status,
            });
          }
        } catch (e) {
          print('⚠️ Gagal parse MQTT payload dari [$topic]: $e → $payload');
        }
      });
    } else {
      print('❌ Status koneksi MQTT: ${_client.connectionStatus}');
      disconnect();
    }
  }

  Future<void> publishOptimalLimit({
    required double minTemperature,
    required double maxTemperature,
    required double minHumidity,
    required double maxHumidity
  }) async {
    if (!_isConnected) {
      debugPrint('⚠️ MQTT belum tersambung, batal publish');
      return;
    }
    final payload = jsonEncode({
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'minHumidity': minHumidity,
      'maxHumidity': maxHumidity,
    });
    final builder = MqttClientPayloadBuilder()..addString(payload);
    _client.publishMessage(
      '${AppConfig.mqttTopicPub}',
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: true,
    );
    debugPrint('📤 [MQTT] Batas optimal dikirim: \n$payload');
  }

  void disconnect() {
    _client.disconnect();
    _isConnected = false;
    print('🔌 Disconnect dari MQTT broker');
  }

  void onDisconnected() {
    _isConnected = false;
    print('⚠️ Disconnect callback terpicu');
  }
}
