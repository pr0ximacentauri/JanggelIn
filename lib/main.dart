import 'package:c3_ppl_agro/const.dart';
import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:c3_ppl_agro/view_models/control_view_model.dart';
import 'package:c3_ppl_agro/models/services/notification_service.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:c3_ppl_agro/views/screens/auth/forgot_password.dart';
import 'package:c3_ppl_agro/views/screens/auth/login.dart';
import 'package:c3_ppl_agro/views/screens/auth/reset_password.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:uni_links/uni_links.dart';
import 'views/screens/home_screen.dart'; 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  await NotificationService.init();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ControlViewModel()),
          ChangeNotifierProvider(create: (_) => SensorViewModel()),
          ChangeNotifierProvider(create: (_) => OptimalLimitViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ],
        child: const JanggelinApp(),
      ),
    ),
  );
}

class JanggelinApp extends StatefulWidget {
  const JanggelinApp({super.key});

  @override
  State<JanggelinApp> createState() => _JanggelinContent();
}

class _JanggelinContent extends State<JanggelinApp> {

  @override
  void initState() {
    super.initState();
    handleDeepLink();
  }

  void handleDeepLink() async {
    final link = await getInitialLink(); // dari package uni_links
    if (link != null && link.contains("reset-password")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResetPassword(fromDeepLink: true),
        ),
      );
    }
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // ignore: deprecated_member_use
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: Page(),
        initialRoute: '/',
        routes: {
          '/login': (context) => Login(),
          '/forgot-password': (context) => ForgotPassword(),
          '/reset-password': (context) => const ResetPassword(),
          '/page': (context) => const BottomNavbar(), 
        }
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return Login(); 
    } else {
      return const HomeScreen(); 
    }
  }
}
