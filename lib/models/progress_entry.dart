class ProgressEntry {
  final String id;
  final String userId;
  final DateTime date;
  final String type;
  final double value;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgressEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.type,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'type': type,
    'value': value,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ProgressEntry.fromJson(Map<String, dynamic> json) => ProgressEntry(
    id: json['id'] as String,
    userId: json['userId'] as String,
    date: DateTime.parse(json['date'] as String),
    type: json['type'] as String,
    value: (json['value'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  ProgressEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? type,
    double? value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProgressEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    type: type ?? this.type,
    value: value ?? this.value,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
