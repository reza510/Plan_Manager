import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/workout_log.dart';

class HistoryService {
  static const String _historyFileName = 'history.json';

  static Future<Directory> _getDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<File> _getHistoryFile() async {
    final dir = await _getDocumentsDirectory();
    return File('${dir.path}/$_historyFileName');
  }

  // ذخیره لیست لاگ‌ها
  static Future<void> saveLogs(List<WorkoutLog> logs) async {
    try {
      final file = await _getHistoryFile();
      final jsonList = logs.map((log) => log.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('خطا در ذخیره تاریخچه: $e');
    }
  }

  // بارگذاری لیست لاگ‌ها
  static Future<List<WorkoutLog>> loadLogs() async {
    try {
      final file = await _getHistoryFile();
      if (!await file.exists()) {
        return [];
      }
      final jsonString = await file.readAsString();
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((item) => WorkoutLog.fromJson(item)).toList();
    } catch (e) {
      throw Exception('خطا در بارگذاری تاریخچه: $e');
    }
  }

  // افزودن یک لاگ جدید
  static Future<void> addLog(WorkoutLog log) async {
    final logs = await loadLogs();
    logs.add(log);
    await saveLogs(logs);
  }

  // دریافت لاگ‌های یک روز خاص
  static Future<List<WorkoutLog>> getLogsForDate(DateTime date) async {
    final logs = await loadLogs();
    return logs
        .where((log) =>
            log.date.year == date.year &&
            log.date.month == date.month &&
            log.date.day == date.day)
        .toList();
  }
}
