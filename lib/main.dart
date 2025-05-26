import 'dart:async';
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
import 'package:app_links/app_links.dart';
import 'views/screens/home_screen.dart'; 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      // Listen deep link stream untuk initial + runtime
      _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleUri(uri);
        }
      }, onError: (err) {
        debugPrint('Failed to receive deep link: $err');
      });
    }
  }

  void _handleUri(Uri uri) {
    if (uri.scheme == 'janggelin' && uri.host == 'reset-password') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResetPassword(fromDeepLink: true),
        ),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const Page(),
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(),
        '/forgot-password': (context) => ForgotPassword(),
        '/reset-password': (context) => const ResetPassword(),
        '/page': (context) => const BottomNavbar(),
      },
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
