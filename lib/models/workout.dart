class Workout {
  final String id;
  final String userId;
  final DateTime date;
  final String exerciseId;
  final int sets;
  final int reps;
  final double weight;
  final int duration;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workout({
    required this.id,
    required this.userId,
    required this.date,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.duration,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'exerciseId': exerciseId,
    'sets': sets,
    'reps': reps,
    'weight': weight,
    'duration': duration,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'] as String,
    userId: json['userId'] as String,
    date: DateTime.parse(json['date'] as String),
    exerciseId: json['exerciseId'] as String,
    sets: json['sets'] as int,
    reps: json['reps'] as int,
    weight: (json['weight'] as num).toDouble(),
    duration: json['duration'] as int,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Workout copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? exerciseId,
    int? sets,
    int? reps,
    double? weight,
    int? duration,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Workout(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    exerciseId: exerciseId ?? this.exerciseId,
    sets: sets ?? this.sets,
    reps: reps ?? this.reps,
    weight: weight ?? this.weight,
    duration: duration ?? this.duration,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
