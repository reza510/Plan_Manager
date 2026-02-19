import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'providers/program_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/main_screens/main_navigation_screen.dart';
import 'services/notification_service.dart';
import 'background/notification_callback.dart'; // برای ثبت callback

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: تنظیمات اولیه نوتیفیکیشن
  final notificationService = NotificationService();
  await notificationService.init();
  // ثبت callback برای آلارم (فقط اندروید)
  // await AndroidAlarmManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProgramProvider()..loadPrograms()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Plan Manager',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              // سایر تنظیمات تم روشن (اختیاری)
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}
