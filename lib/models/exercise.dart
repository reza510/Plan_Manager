import 'package:json_annotation/json_annotation.dart';
import '../utils/date_formatter.dart';

part 'exercise.g.dart';

// enum برای نوع ست
enum SetType {
  @JsonValue('repetition')
  repetition, // تمرین بر اساس تکرار
  @JsonValue('time')
  time // تمرین بر اساس زمان
}

@JsonSerializable()
class Exercise {
  final String exerciseName;
  final int sets;
  final int reps; // تعداد تکرار
  final int restTime; // زمان استراحت (ثانیه)

  @JsonKey(fromJson: _dateTimeFromString, toJson: _stringFromDateTime)
  final DateTime date; // تاریخ انجام تمرین

  final String? imagePath; // مسیر نسبی تصویر
  final String? videoLink; // لینک ویدیو
  final String? description; // توضیحات
  final String primaryMuscle; // عضله هدف اصلی
  final String? secondaryMuscle; // عضله هدف جانبی

  final SetType setType; // نوع ست

  @JsonKey(defaultValue: 1)
  final int difficulty; // سطح سختی (۱ تا ۵)

  final int? targetTime; // زمان مد نظر (برای setType=time) - ثانیه

  final String? equipment; // ابزار تمرین
  final String? exerciseType; // نوع تمرین (مثلاً compound, isolation)
  final double? weight; // وزنه (کیلوگرم)

  Exercise({
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.date,
    this.imagePath,
    this.videoLink,
    this.description,
    required this.primaryMuscle,
    this.secondaryMuscle,
    required this.setType,
    required this.difficulty,
    this.targetTime,
    this.equipment,
    this.exerciseType,
    this.weight,
  });

  // تبدیل تاریخ از String به DateTime
  static DateTime _dateTimeFromString(String dateStr) {
    return DateFormatter.parseDate(dateStr) ?? DateTime.now();
  }

  // تبدیل DateTime به String
  static String _stringFromDateTime(DateTime date) {
    return DateFormatter.formatDate(date);
  }

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
