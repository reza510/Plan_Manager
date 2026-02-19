import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// تابع callback که هر روز در ساعت مشخص اجرا می‌شود
@pragma('vm:entry-point')
void notificationCallback() {
  // نمایش نوتیفیکیشن
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // مقداردهی اولیه (نیاز به تنظیمات مشابه main)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'daily_reminder_channel',
    'یادآور روزانه',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  flutterLocalNotificationsPlugin.show(
    0,
    'زمان تمرین',
    'وقت تمرین است! برنامه امروز را شروع کنید.',
    platformDetails,
  );
}
