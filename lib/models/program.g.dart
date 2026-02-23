// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Program _$ProgramFromJson(Map<String, dynamic> json) => Program(
      programName: json['programName'] as String,
      startDate: Program._dateTimeFromString(json['startDate'] as String),
      endDate: Program._dateTimeFromString(json['endDate'] as String),
      workouts: (json['workouts'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProgramToJson(Program instance) => <String, dynamic>{
      'programName': instance.programName,
      'startDate': Program._stringFromDateTime(instance.startDate),
      'endDate': Program._stringFromDateTime(instance.endDate),
      'workouts': instance.workouts,
    };
