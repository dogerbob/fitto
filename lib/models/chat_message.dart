class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String,
    message: json['message'] as String,
    isUser: json['isUser'] as bool,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  ChatMessage copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
  }) => ChatMessage(
    id: id ?? this.id,
    message: message ?? this.message,
    isUser: isUser ?? this.isUser,
    timestamp: timestamp ?? this.timestamp,
  );
}
