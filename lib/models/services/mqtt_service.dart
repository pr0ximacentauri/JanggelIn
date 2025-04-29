import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:c3_ppl_agro/const.dart';
import 'dart:convert';

class MqttService {
  late MqttServerClient client;

  Future<void> connect({
    required Function(Map<String, dynamic>) onMessageReceived,
  }) async {
    client = MqttServerClient(AppConfig.mqttBroker, '');
    client.port = AppConfig.mqttPort;
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.logging(on: true);

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('MQTT connection failed: $e');
      disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Connected to MQTT broker');

      client.subscribe(AppConfig.mqttTopic, MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print('Received MQTT payload: $payload');

        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          onMessageReceived(data);
        } catch (e) {
          print('Error parsing MQTT message: $e');
        }
      });
    } else {
      print('Connection failed: ${client.connectionStatus}');
      disconnect();
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void onDisconnected() {
    print('Disconnected from MQTT broker');
  }
}

