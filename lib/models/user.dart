class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final int dailyCalorieGoal;
  final int dailyWaterGoal;
  final int dailyStepsGoal;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.dailyCalorieGoal,
    required this.dailyWaterGoal,
    required this.dailyStepsGoal,
    this.isPremium = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'profileImage': profileImage,
    'weight': weight,
    'height': height,
    'age': age,
    'gender': gender,
    'dailyCalorieGoal': dailyCalorieGoal,
    'dailyWaterGoal': dailyWaterGoal,
    'dailyStepsGoal': dailyStepsGoal,
    'isPremium': isPremium,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    profileImage: json['profileImage'] as String?,
    weight: (json['weight'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
    age: json['age'] as int,
    gender: json['gender'] as String,
    dailyCalorieGoal: json['dailyCalorieGoal'] as int,
    dailyWaterGoal: json['dailyWaterGoal'] as int,
    dailyStepsGoal: json['dailyStepsGoal'] as int,
    isPremium: json['isPremium'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    double? weight,
    double? height,
    int? age,
    String? gender,
    int? dailyCalorieGoal,
    int? dailyWaterGoal,
    int? dailyStepsGoal,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    profileImage: profileImage ?? this.profileImage,
    weight: weight ?? this.weight,
    height: height ?? this.height,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
    dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
    dailyStepsGoal: dailyStepsGoal ?? this.dailyStepsGoal,
    isPremium: isPremium ?? this.isPremium,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
