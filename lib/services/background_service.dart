// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:JanggelIn/services/mqtt_service.dart';
// import 'package:JanggelIn/services/notification_service.dart';

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//       notificationChannelId: 'sensor_monitoring',
//       initialNotificationTitle: 'Monitoring Sensor Aktif',
//       initialNotificationContent: 'Aplikasi berjalan di latar belakang',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );

//   await service.startService();
// }

// bool onIosBackground(ServiceInstance service) {
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   try {
//     DartPluginRegistrant.ensureInitialized();

//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: 'Monitoring Sensor',
//         content: 'Layanan masih berjalan',
//       );
//     }

//     final mqtt = MqttService();

//     await mqtt.connect(
//       onSensorMessage: (data) async {
//         final temp = (data['temperature'] ?? 0.0).toDouble();
//         final humid = (data['humidity'] ?? 0.0).toDouble();

//         await NotificationService.showNotification(
//           title: 'Data Sensor Baru',
//           body: 'Suhu: $temp°C, Kelembapan: $humid%',
//         );
//       },
//       onControlStatusChanged: (_) {},
//     );

//     Timer.periodic(Duration(minutes: 15), (timer) async {
//       if (service is AndroidServiceInstance) {
//         service.setForegroundNotificationInfo(
//           title: 'Monitoring Sensor',
//           content: 'Update setiap 15 menit',
//         );
//       }
//     });
//   } catch (e, stack) {
//     print('Error in BackgroundService onStart: $e\n$stack');
//   }
// }
