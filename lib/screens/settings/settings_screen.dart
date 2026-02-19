import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/import_export_service.dart';
import '../../services/permission_service.dart';

class SettingsScreen extends StatelessWidget {
  final permissionService = PermissionService();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    Future<void> _toggleNotifications(bool value) async {
      if (value) {
        // اگر کاربر می‌خواهد فعال کند، ابتدا مجوز را بررسی کن
        bool hasPermission =
            await permissionService.checkNotificationPermission();
        if (!hasPermission) {
          hasPermission =
              await permissionService.requestNotificationPermission();
        }
        if (hasPermission) {
          settings.setNotificationsEnabled(true);
        } else {
          // اگر مجوز نداد، سوئیچ را خاموش نگه دار و پیام نمایش بده
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('برای دریافت یادآور، مجوز نوتیفیکیشن لازم است')),
          );
        }
      } else {
        settings.setNotificationsEnabled(false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          // پروفایل
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('نام کاربر'),
            subtitle: const Text('کاربر مهمان'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: ویرایش نام
              },
            ),
          ),
          const Divider(),
          // تنظیمات نوتیفیکیشن
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('یادآور تمرین'),
            subtitle: Text(settings.notificationsEnabled
                ? 'فعال - ${settings.notificationTime.format(context)}'
                : 'غیرفعال'),
            value: settings.notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          if (settings.notificationsEnabled)
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('زمان یادآوری'),
              subtitle: Text(settings.notificationTime.format(context)),
              onTap: () async {
                final TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: settings.notificationTime,
                );
                if (newTime != null) {
                  settings.setNotificationTime(newTime);
                }
              },
            ),
          const Divider(),
          // تم
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('تم'),
            subtitle: Text(settings.themeMode == ThemeMode.dark
                ? 'تاریک'
                : settings.themeMode == ThemeMode.light
                    ? 'روشن'
                    : 'همراه با سیستم'),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              onChanged: (mode) {
                if (mode != null) settings.setThemeMode(mode);
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('تاریک'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('روشن'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('همراه با سیستم'),
                ),
              ],
            ),
          ),
          const Divider(),
          // ایمپورت/اکسپورت
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('خروجی (پشتیبان)'),
            subtitle: const Text('ذخیره تمام داده‌ها در فایل JSON'),
            onTap: () async {
              try {
                await ImportExportService.exportAllData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('پشتیبان با موفقیت ذخیره شد')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطا: $e')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('ورودی (بازیابی)'),
            subtitle: const Text('بارگذاری داده‌ها از فایل JSON'),
            onTap: () async {
              try {
                await ImportExportService.importAllData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('داده‌ها با موفقیت بازیابی شدند')),
                );
                // TODO: به‌روزرسانی Provider‌ها
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطا: $e')),
                );
              }
            },
          ),
          const Divider(),
          // درباره
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('درباره برنامه'),
            subtitle: const Text('نسخه 1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Fitness App',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.fitness_center, size: 50),
              );
            },
          ),
        ],
      ),
    );
  }
}
