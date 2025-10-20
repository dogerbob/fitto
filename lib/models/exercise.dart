class Exercise {
  final String id;
  final String name;
  final String category;
  final String muscleGroup;
  final String description;
  final String difficulty;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroup,
    required this.description,
    required this.difficulty,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'muscleGroup': muscleGroup,
    'description': description,
    'difficulty': difficulty,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    muscleGroup: json['muscleGroup'] as String,
    description: json['description'] as String,
    difficulty: json['difficulty'] as String,
    imageUrl: json['imageUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Exercise copyWith({
    String? id,
    String? name,
    String? category,
    String? muscleGroup,
    String? description,
    String? difficulty,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    muscleGroup: muscleGroup ?? this.muscleGroup,
    description: description ?? this.description,
    difficulty: difficulty ?? this.difficulty,
    imageUrl: imageUrl ?? this.imageUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
