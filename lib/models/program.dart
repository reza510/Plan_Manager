import 'package:json_annotation/json_annotation.dart';
import 'exercise.dart';
import '../utils/date_formatter.dart';

part 'program.g.dart';

@JsonSerializable()
class Program {
  final String programName; // نام برنامه

  @JsonKey(fromJson: _dateTimeFromString, toJson: _stringFromDateTime)
  final DateTime startDate; // تاریخ شروع

  @JsonKey(fromJson: _dateTimeFromString, toJson: _stringFromDateTime)
  final DateTime endDate; // تاریخ پایان

  final List<Exercise> workouts; // لیست تمرینات (هر ردیف)

  Program({
    required this.programName,
    required this.startDate,
    required this.endDate,
    required this.workouts,
  });

  static DateTime _dateTimeFromString(String dateStr) {
    return DateFormatter.parseDate(dateStr) ?? DateTime.now();
  }

  static String _stringFromDateTime(DateTime date) {
    return DateFormatter.formatDate(date);
  }

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramToJson(this);
}
