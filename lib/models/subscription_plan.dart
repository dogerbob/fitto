class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String duration;
  final List<String> features;
  final bool isPopular;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    this.isPopular = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'duration': duration,
    'features': features,
    'isPopular': isPopular,
  };

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    duration: json['duration'] as String,
    features: (json['features'] as List<dynamic>).map((e) => e as String).toList(),
    isPopular: json['isPopular'] as bool? ?? false,
  );

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    double? price,
    String? duration,
    List<String>? features,
    bool? isPopular,
  }) => SubscriptionPlan(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    duration: duration ?? this.duration,
    features: features ?? this.features,
    isPopular: isPopular ?? this.isPopular,
  );
}
