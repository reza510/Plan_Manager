// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      exerciseName: json['exerciseName'] as String,
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      restTime: (json['restTime'] as num).toInt(),
      date: Exercise._dateTimeFromString(json['date'] as String),
      imagePath: json['imagePath'] as String?,
      videoLink: json['videoLink'] as String?,
      description: json['description'] as String?,
      primaryMuscle: json['primaryMuscle'] as String,
      secondaryMuscle: json['secondaryMuscle'] as String?,
      setType: $enumDecode(_$SetTypeEnumMap, json['setType']),
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      targetTime: (json['targetTime'] as num?)?.toInt(),
      equipment: json['equipment'] as String?,
      exerciseType: json['exerciseType'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'exerciseName': instance.exerciseName,
      'sets': instance.sets,
      'reps': instance.reps,
      'restTime': instance.restTime,
      'date': Exercise._stringFromDateTime(instance.date),
      'imagePath': instance.imagePath,
      'videoLink': instance.videoLink,
      'description': instance.description,
      'primaryMuscle': instance.primaryMuscle,
      'secondaryMuscle': instance.secondaryMuscle,
      'setType': _$SetTypeEnumMap[instance.setType]!,
      'difficulty': instance.difficulty,
      'targetTime': instance.targetTime,
      'equipment': instance.equipment,
      'exerciseType': instance.exerciseType,
      'weight': instance.weight,
    };

const _$SetTypeEnumMap = {
  SetType.repetition: 'repetition',
  SetType.time: 'time',
};
