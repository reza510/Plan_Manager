import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // الگوی Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // نمونه اصلی پلاگین نوتیفیکیشن
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // تنظیمات کانال نوتیفیکیشن برای اندروید
  // این کانال باید با کانالی که در زمان زمان‌بندی استفاده می‌شود یکسان باشد
  final AndroidNotificationDetails _androidDetails =
      const AndroidNotificationDetails(
    'fitness_channel_id', // شناسه یکتا برای کانال
    'یادآور تمرین', // نام کانال (نمایش داده می‌شود)
    channelDescription: 'کانال یادآور تمرینات ورزشی', // توضیحات کانال
    importance: Importance.high, // اهمیت بالا (نمایش به عنوان heads-up)
    priority: Priority.high, // اولویت بالا
    playSound: true, // پخش صدا
    enableVibration: true, // فعال کردن لرزش
  );

  // تنظیمات پیش‌فرض برای iOS (می‌توانید صدا و ... را نیز تنظیم کنید)
  final DarwinNotificationDetails _iOSDetails =
      const DarwinNotificationDetails();

  // مقداردهی اولیه سرویس
  Future<void> init() async {
    // تنظیمات اولیه برای اندروید (آیکون پیش‌فرض)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // تنظیمات اولیه برای iOS (در صورت نیاز)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // تلفیق تنظیمات هر دو پلتفرم
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // مقداردهی اولیه پلاگین
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // مقداردهی اولیه منطقه زمانی (برای استفاده از زمان‌بندی دقیق)
    tz.initializeTimeZones();
  }

  // نمایش نوتیفیکیشن فوری (برای تست سریع)
  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'fitness_channel_id',
        'یادآور تمرین',
        channelDescription: 'کانال یادآور تمرینات ورزشی',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // شناسه نوتیفیکیشن (برای لغو بعدی)
      title,
      body,
      details,
    );
  }

  // زمان‌بندی نوتیفیکیشن روزانه در ساعت مشخص
  Future<void> scheduleDailyNotification({
    required int id, // شناسه یکتا برای این نوتیفیکیشن
    required String title,
    required String body,
    required int hour, // ساعت (۰-۲۳)
    required int minute, // دقیقه (۰-۵۹)
  }) async {
    final now = DateTime.now();
    // ساخت تاریخ و زمان بر اساس ساعت و دقیقه داده شده در روز جاری
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    // اگر زمان تعیین‌شده از الان گذشته باشد، برای فردا زمان‌بندی کن
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // تبدیل به زمان محلی با استفاده از پکیج timezone
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // تنظیمات نوتیفیکیشن
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'fitness_channel_id',
        'یادآور تمرین',
        channelDescription: 'کانال یادآور تمرینات ورزشی',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    // زمان‌بندی
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // تعیین اینکه تاریخ مطلق است
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // تکرار روزانه بر اساس زمان (ساعت و دقیقه)
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // لغو همه نوتیفیکیشن‌های زمان‌بندی شده
  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // لغو یک نوتیفیکیشن خاص بر اساس شناسه
  Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
