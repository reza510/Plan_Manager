import 'package:json_annotation/json_annotation.dart';
import '../utils/date_formatter.dart';

part 'workout_log.g.dart';

@JsonSerializable()
class WorkoutLog {
  final String exerciseName;
  final DateTime date; // تاریخ انجام
  final int setsCompleted;
  final int repsPerSet; // تکرار انجام شده (میانگین یا اولین ست)
  final double? weightUsed; // وزنه استفاده شده
  final int duration; // مدت زمان تمرین (ثانیه) - برای تمرینات زمانی
  final String programName; // نام برنامه‌ای که این تمرین متعلق به آن است

  WorkoutLog({
    required this.exerciseName,
    required this.date,
    required this.setsCompleted,
    required this.repsPerSet,
    this.weightUsed,
    required this.duration,
    required this.programName,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutLogToJson(this);
}
