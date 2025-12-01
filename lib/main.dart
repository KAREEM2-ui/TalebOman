import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'utils/Thems/Theme.dart';
import 'package:provider/provider.dart';
import 'Providers/ThemeProvider.dart';
import 'Providers/AuthProvider.dart';
import 'Screens/Auth/SplashScreen.dart';
import 'Screens/User/Notifications/notificationService.dart';

void main(List<String> args) async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(create: (_) => AuthenticationProvider()),
      ],
      child: const MyApp(),
    )

  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scholarship Finder',

      // Light theme
      theme: Themes.lightTheme,

      // Dark theme
      darkTheme: Themes.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const SplashScreen(),
    );
  }
}