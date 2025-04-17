import 'package:c3_ppl_agro/const.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/control_view_model.dart';
import 'views/screens/home_screen.dart';
import 'package:device_preview/device_preview.dart';

void main() async{
  // print("Supabase URL: ${AppConfig.supabaseUrl}");
  // print("MQTT Broker: ${AppConfig.mqttBroker}");
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (_) => ControlViewModel()),
          ChangeNotifierProvider(create: (_) => SensorViewModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // ignore: deprecated_member_use
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: HomeScreen(),
    );
  }
}