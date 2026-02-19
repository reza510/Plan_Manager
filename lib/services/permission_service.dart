import 'package:flutter/services.dart';

class PermissionService {
  static const MethodChannel _channel =
      MethodChannel('plan_manager/permissions');

  /// بررسی وضعیت مجوز نوتیفیکیشن
  /// برگردانده می شود: true = مجاز, false = غیرمجاز
  Future<bool> checkNotificationPermission() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('checkNotificationPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      print('خطا در بررسی مجوز: ${e.message}');
      return false;
    }
  }

  /// درخواست مجوز نوتیفیکیشن
  /// برگردانده می شود: true = مجاز, false = رد شده
  Future<bool> requestNotificationPermission() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('requestNotificationPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      print('خطا در درخواست مجوز: ${e.message}');
      return false;
    }
  }
}
