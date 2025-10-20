class NutritionEntry {
  final String id;
  final String userId;
  final DateTime date;
  final String mealType;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final String servingSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  NutritionEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.mealType,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.servingSize,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'mealType': mealType,
    'name': name,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
    'servingSize': servingSize,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory NutritionEntry.fromJson(Map<String, dynamic> json) => NutritionEntry(
    id: json['id'] as String,
    userId: json['userId'] as String,
    date: DateTime.parse(json['date'] as String),
    mealType: json['mealType'] as String,
    name: json['name'] as String,
    calories: json['calories'] as int,
    protein: (json['protein'] as num).toDouble(),
    carbs: (json['carbs'] as num).toDouble(),
    fats: (json['fats'] as num).toDouble(),
    servingSize: json['servingSize'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  NutritionEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? mealType,
    String? name,
    int? calories,
    double? protein,
    double? carbs,
    double? fats,
    String? servingSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NutritionEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    mealType: mealType ?? this.mealType,
    name: name ?? this.name,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fats: fats ?? this.fats,
    servingSize: servingSize ?? this.servingSize,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
