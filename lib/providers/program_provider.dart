import 'package:flutter/material.dart';
import '../models/program.dart';
import '../services/storage_service.dart';

class ProgramProvider extends ChangeNotifier {
  List<Program> _programs = [];

  List<Program> get programs => _programs;

  // بارگذاری اولیه
  Future<void> loadPrograms() async {
    try {
      _programs = await StorageService.loadPrograms();
      notifyListeners();
    } catch (e) {
      print('خطا در بارگذاری برنامه‌ها: $e');
      _programs = [];
      notifyListeners();
    }
  }

  // افزودن برنامه جدید
  Future<void> addProgram(Program program) async {
    try {
      await StorageService.addProgram(program);
      _programs.add(program);
      notifyListeners();
    } catch (e) {
      print('خطا در افزودن برنامه: $e');
    }
  }

  // حذف برنامه
  Future<void> deleteProgram(String programName) async {
    try {
      await StorageService.deleteProgram(programName);
      _programs.removeWhere((p) => p.programName == programName);
      notifyListeners();
    } catch (e) {
      print('خطا در حذف برنامه: $e');
    }
  }

  // ویرایش برنامه
  Future<void> updateProgram(String oldName, Program updatedProgram) async {
    try {
      await StorageService.updateProgram(oldName, updatedProgram);
      final index = _programs.indexWhere((p) => p.programName == oldName);
      if (index != -1) {
        _programs[index] = updatedProgram;
        notifyListeners();
      }
    } catch (e) {
      print('خطا در ویرایش برنامه: $e');
    }
  }

  // ایجاد یک برنامه نمونه برای تست (فعلاً)
  Program createSampleProgram() {
    return Program(
      programName: 'برنامه نمونه',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      workouts: [],
    );
  }
}
