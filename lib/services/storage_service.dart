import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/program.dart';

class StorageService {
  static const String _programsFileName = 'programs.json';

  // دریافت دایرکتوری اسناد برنامه
  static Future<Directory> _getDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // دریافت فایل programs.json
  static Future<File> _getProgramsFile() async {
    final dir = await _getDocumentsDirectory();
    return File('${dir.path}/$_programsFileName');
  }

  // ذخیره لیست برنامه‌ها
  static Future<void> savePrograms(List<Program> programs) async {
    try {
      final file = await _getProgramsFile();
      final jsonList = programs.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('خطا در ذخیره برنامه‌ها: $e');
    }
  }

  // بارگذاری لیست برنامه‌ها
  static Future<List<Program>> loadPrograms() async {
    try {
      final file = await _getProgramsFile();
      if (!await file.exists()) {
        return []; // اگر فایل وجود نداشت، لیست خالی برگردان
      }
      final jsonString = await file.readAsString();
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((item) => Program.fromJson(item)).toList();
    } catch (e) {
      throw Exception('خطا در بارگذاری برنامه‌ها: $e');
    }
  }

  // اضافه کردن یک برنامه جدید
  static Future<void> addProgram(Program program) async {
    final programs = await loadPrograms();
    programs.add(program);
    await savePrograms(programs);
  }

  // حذف یک برنامه
  static Future<void> deleteProgram(String programName) async {
    final programs = await loadPrograms();
    programs.removeWhere((p) => p.programName == programName);
    await savePrograms(programs);
  }

  // ویرایش یک برنامه
  static Future<void> updateProgram(
      String oldName, Program updatedProgram) async {
    final programs = await loadPrograms();
    final index = programs.indexWhere((p) => p.programName == oldName);
    if (index != -1) {
      programs[index] = updatedProgram;
      await savePrograms(programs);
    }
  }
}
