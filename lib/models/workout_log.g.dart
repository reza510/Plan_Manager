// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutLog _$WorkoutLogFromJson(Map<String, dynamic> json) => WorkoutLog(
      exerciseName: json['exerciseName'] as String,
      date: DateTime.parse(json['date'] as String),
      setsCompleted: (json['setsCompleted'] as num).toInt(),
      repsPerSet: (json['repsPerSet'] as num).toInt(),
      weightUsed: (json['weightUsed'] as num?)?.toDouble(),
      duration: (json['duration'] as num).toInt(),
      programName: json['programName'] as String,
    );

Map<String, dynamic> _$WorkoutLogToJson(WorkoutLog instance) =>
    <String, dynamic>{
      'exerciseName': instance.exerciseName,
      'date': instance.date.toIso8601String(),
      'setsCompleted': instance.setsCompleted,
      'repsPerSet': instance.repsPerSet,
      'weightUsed': instance.weightUsed,
      'duration': instance.duration,
      'programName': instance.programName,
    };
