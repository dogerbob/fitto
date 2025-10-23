// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutritional_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutritionalPlan _$NutritionalPlanFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'description',
      'creation_date',
      'start',
      'end',
      'only_logging',
      'goal_energy',
      'goal_protein',
      'goal_carbohydrates',
      'goal_fat',
      'goal_fiber',
    ],
  );
  return NutritionalPlan(
    id: (json['id'] as num?)?.toInt(),
    description: json['description'] as String,
    creationDate: json['creation_date'] == null
        ? null
        : DateTime.parse(json['creation_date'] as String),
    startDate: DateTime.parse(json['start'] as String),
    endDate: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    onlyLogging: json['only_logging'] as bool? ?? false,
    goalEnergy: json['goal_energy'] as num?,
    goalProtein: json['goal_protein'] as num?,
    goalCarbohydrates: json['goal_carbohydrates'] as num?,
    goalFat: json['goal_fat'] as num?,
    goalFiber: json['goal_fiber'] as num?,
  );
}

Map<String, dynamic> _$NutritionalPlanToJson(NutritionalPlan instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'creation_date': dateToUtcIso8601(instance.creationDate),
  'start': dateToYYYYMMDD(instance.startDate),
  'end': dateToYYYYMMDD(instance.endDate),
  'only_logging': instance.onlyLogging,
  'goal_energy': instance.goalEnergy,
  'goal_protein': instance.goalProtein,
  'goal_carbohydrates': instance.goalCarbohydrates,
  'goal_fat': instance.goalFat,
  'goal_fiber': instance.goalFiber,
};
