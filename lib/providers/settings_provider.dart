import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart'; // اضافه شد

class SettingsProvider extends ChangeNotifier {
  // ... کلیدهای SharedPreferences
  static const String _themeModeKey = 'themeMode';
  static const String _notificationsEnabledKey = 'notificationsEnabled';
  static const String _notificationTimeKey = 'notificationTime';
  static const String _currentProgramKey = 'currentProgram';

  // ... متغیرها
  ThemeMode _themeMode = ThemeMode.dark;
  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  String? _currentProgramName;

  // نمونه سرویس نوتیفیکیشن
  final NotificationService _notificationService = NotificationService();

  // ... getterها
  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  TimeOfDay get notificationTime => _notificationTime;
  String? get currentProgramName => _currentProgramName;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeModeKey) ?? 2;
    _themeMode = ThemeMode.values[themeIndex];
    _notificationsEnabled = prefs.getBool(_notificationsEnabledKey) ?? false;
    final timeStr = prefs.getString(_notificationTimeKey);
    if (timeStr != null) {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        _notificationTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
    _currentProgramName = prefs.getString(_currentProgramKey);
    notifyListeners();

    // پس از بارگذاری تنظیمات، زمان‌بندی نوتیفیکیشن را اعمال کن
    _updateNotificationSchedule();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  // متد تنظیم وضعیت نوتیفیکیشن
  Future<void> setNotificationsEnabled(bool value) async {
    if (_notificationsEnabled == value) return;
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, value);
    _updateNotificationSchedule(); // به‌روزرسانی زمان‌بندی
    notifyListeners();
  }

  // متد تنظیم زمان نوتیفیکیشن
  Future<void> setNotificationTime(TimeOfDay time) async {
    if (_notificationTime == time) return;
    _notificationTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationTimeKey, '${time.hour}:${time.minute}');
    _updateNotificationSchedule(); // به‌روزرسانی زمان‌بندی
    notifyListeners();
  }

  Future<void> setCurrentProgram(String? programName) async {
    if (_currentProgramName == programName) return;
    _currentProgramName = programName;
    final prefs = await SharedPreferences.getInstance();
    if (programName != null) {
      await prefs.setString(_currentProgramKey, programName);
    } else {
      await prefs.remove(_currentProgramKey);
    }
    notifyListeners();
  }

  // متد داخلی برای اعمال زمان‌بندی بر اساس تنظیمات فعلی
  void _updateNotificationSchedule() async {
    // ابتدا همه نوتیفیکیشن‌های قبلی را لغو کن
    await _notificationService.cancelAll();
    if (_notificationsEnabled) {
      // سپس نوتیفیکیشن جدید با زمان جدید زمان‌بندی کن
      await _notificationService.scheduleDailyNotification(
        id: 1, // می‌توانید از یک شناسه ثابت استفاده کنید
        title: 'یادآور تمرین',
        body: _currentProgramName != null
            ? 'پاشو پسر,الان وقت انجام برنامه"${_currentProgramName}شده!!"'
            : 'وقت تمرینه,برنامه که میخوای رو شروع کن.',
        hour: _notificationTime.hour,
        minute: _notificationTime.minute,
      );
    }
  }
}
