// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class MqttService {
//   late MqttServerClient _client;

//   MqttService() {
//     _client = MqttServerClient(dotenv.env['MQTT_BROKER']!, '');
//     _client.port = int.parse(dotenv.env['MQTT_PORT']!);
//     _client.logging(on: false);
//     _client.keepAlivePeriod = 20;
//   }

//   Future<void> connect() async {
//     try {
//       _client.setProtocolV311();
//       _client.connect(dotenv.env['MQTT_USERNAME'], dotenv.env['MQTT_PASSWORD']);
//     } catch (e) {
//       print("MQTT Connection Error: $e");
//     }
//   }

//   void sendCommand(String deviceId, bool status) {
//     final builder = MqttClientPayloadBuilder();
//     builder.addString(status ? "ON" : "OFF");

//     final topic = dotenv.env['MQTT_TOPIC']!;
//     _client.publishMessage("$topic/$deviceId", MqttQos.atMostOnce, builder.payload!);
//   }

//   void disconnect() {
//     _client.disconnect();
//   }
// }

import 'dart:async';

class MqttService {
  bool _isConnected = false;

  Future<void> connect() async {
    _isConnected = true;
    print("MQTT Mock Connected");
  }

  void sendCommand(String deviceId, bool status) {
    print("Mock MQTT: Command sent to $deviceId - Status: $status");
  }

  void disconnect() {
    _isConnected = false;
    print("MQTT Mock Disconnected");
  }
}
