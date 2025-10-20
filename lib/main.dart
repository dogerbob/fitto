import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitto/theme.dart';
import 'package:fitto/screens/splash_screen.dart';
import 'package:fitto/services/notification_service.dart';
import 'package:fitto/providers/app_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(const FittoApp());
}

class FittoApp extends StatelessWidget {
  const FittoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: MaterialApp(
        title: 'Fitto',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
