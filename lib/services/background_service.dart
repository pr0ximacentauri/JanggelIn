import 'dart:async';
import 'dart:ui';
import 'package:JanggelIn/services/mqtt_service.dart';
import 'package:JanggelIn/services/notification_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'sensor_monitoring',
      initialNotificationTitle: 'Monitoring Sensor Aktif',
      initialNotificationContent: 'Aplikasi sedang berjalan di latar belakang',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  await service.startService();
}

bool onIosBackground(ServiceInstance service) {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final mqtt = MqttService();
  await mqtt.connect(
    onSensorMessage: (data) {
      final temp = (data['temperature'] ?? 0.0).toDouble();
      final humid = (data['humidity'] ?? 0.0).toDouble();

      NotificationService.showNotification(
        title: 'Update Sensor',
        body: 'Suhu: $temp°C, Kelembapan: $humid%',
      );
    },
    onControlStatusChanged: (_) {},
  );

  // Optional: Update notifikasi tiap interval
  Timer.periodic(Duration(minutes: 15), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Monitoring Sensor',
        content: 'Service masih aktif di latar belakang',
      );
    }
  });
}
