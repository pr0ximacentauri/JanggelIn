import 'package:c3_ppl_agro/const.dart';
import 'package:c3_ppl_agro/views/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/control_view_model.dart';
import 'views/screens/home_screen.dart';

void main() async{
  print("Supabase URL: ${AppConfig.supabaseUrl}");
  print("MQTT Broker: ${AppConfig.mqttBroker}");
  runApp(
    MultiProvider(
        providers: [
          //ChangeNotifierProvider(create: (context) => DeviceViewModel()),
        ],
    child: MyApp()
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
        home: HomeScreen(),
        // account: AccountScreen(),
    );
  }
}