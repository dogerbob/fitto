import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: isUser
            ? LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
          color: isUser ? null : (isDark ? Color(0xFF2A2A2A) : Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isUser ? Radius.circular(20) : Radius.circular(4),
            bottomRight: isUser ? Radius.circular(4) : Radius.circular(20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : theme.colorScheme.onSurface,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
