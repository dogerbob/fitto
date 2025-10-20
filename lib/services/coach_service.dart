import 'package:fitto/models/chat_message.dart';
import 'package:fitto/services/storage_service.dart';
import 'package:fitto/utils/api_placeholders.dart';

class CoachService {
  final StorageService _storage = StorageService();
  List<ChatMessage> _messages = [];

  Future<void> initialize() async {
    await _loadMessages();
    if (_messages.isEmpty) {
      await _createWelcomeMessage();
    }
  }

  Future<void> _loadMessages() async {
    final list = await _storage.getList(StorageService.chatMessagesKey);
    _messages = list.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<void> _createWelcomeMessage() async {
    final now = DateTime.now();
    _messages = [
      ChatMessage(
        id: '1',
        message: 'Hello! I\'m your AI fitness coach. I\'m here to help you achieve your fitness goals. Feel free to ask me anything about workouts, nutrition, or motivation!',
        isUser: false,
        timestamp: now,
      ),
    ];
    await _saveMessages();
  }

  Future<void> _saveMessages() async {
    await _storage.saveList(StorageService.chatMessagesKey, _messages.map((e) => e.toJson()).toList());
  }

  List<ChatMessage> get messages => _messages;

  Future<void> sendMessage(String message) async {
    final now = DateTime.now();
    
    final userMessage = ChatMessage(
      id: 'msg_${now.millisecondsSinceEpoch}',
      message: message,
      isUser: true,
      timestamp: now,
    );
    _messages.add(userMessage);
    await _saveMessages();

    final response = await ApiPlaceholders.getAICoachResponse(message);
    
    final coachMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      message: response,
      isUser: false,
      timestamp: DateTime.now(),
    );
    _messages.add(coachMessage);
    await _saveMessages();
  }

  List<String> getMotivationalQuotes() => [
    'The only bad workout is the one that didn\'t happen.',
    'Your body can stand almost anything. It\'s your mind you have to convince.',
    'Success starts with self-discipline.',
    'Push yourself because no one else is going to do it for you.',
    'Great things never come from comfort zones.',
    'Don\'t wish for it, work for it.',
    'The pain you feel today will be the strength you feel tomorrow.',
  ];

  String getDailyMotivation() {
    final quotes = getMotivationalQuotes();
    final index = DateTime.now().day % quotes.length;
    return quotes[index];
  }

  Future<void> clearChat() async {
    _messages.clear();
    await _createWelcomeMessage();
  }
}
