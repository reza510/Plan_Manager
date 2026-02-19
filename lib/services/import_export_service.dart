import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/program.dart';
import '../models/workout_log.dart';
import 'storage_service.dart';
import 'history_service.dart';

class ImportExportService {
  // اکسپورت تمام داده‌ها به یک فایل JSON
  static Future<void> exportAllData() async {
    try {
      final programs = await StorageService.loadPrograms();
      final history = await HistoryService.loadLogs();

      final exportData = {
        'programs': programs.map((p) => p.toJson()).toList(),
        'history': history.map((h) => h.toJson()).toList(),
        'exportDate': DateTime.now().toIso8601String(),
      };

      final jsonString = jsonEncode(exportData);

      // انتخاب محل ذخیره توسط کاربر
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'ذخیره فایل پشتیبان',
        fileName:
            'fitness_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(jsonString);
      }
    } catch (e) {
      throw Exception('خطا در خروجی گرفتن: $e');
    }
  }

  // ایمپورت داده‌ها از فایل JSON (جایگزینی کامل)
  static Future<void> importAllData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) return;

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      final programsJson = data['programs'] as List? ?? [];
      final historyJson = data['history'] as List? ?? [];

      final programs = programsJson.map((p) => Program.fromJson(p)).toList();
      final history = historyJson.map((h) => WorkoutLog.fromJson(h)).toList();

      // ذخیره در حافظه داخلی
      await StorageService.savePrograms(programs);
      await HistoryService.saveLogs(history);
    } catch (e) {
      throw Exception('خطا در ورودی گرفتن: $e');
    }
  }
}
