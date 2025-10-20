import 'package:flutter/material.dart';
import 'package:fitto/services/coach_service.dart';
import 'package:fitto/widgets/chat_bubble.dart';
import 'package:fitto/utils/localizations.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final CoachService _coachService = CoachService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _coachService.initialize();
    if (mounted) {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(locale),
            Expanded(
              child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildChatList(),
            ),
            _buildMessageInput(locale),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String locale) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Color(0xFFFFB4C8).withValues(alpha: 0.3), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(Icons.psychology, color: Colors.white, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.get('coach', locale), style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Your AI Fitness Assistant', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () async {
                  await _coachService.clearChat();
                  setState(() {});
                  _scrollToBottom();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    final messages = _coachService.messages;
    
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatBubble(
          message: message.message,
          isUser: message.isUser,
          timestamp: message.timestamp,
        );
      },
    );
  }

  Widget _buildMessageInput(String locale) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.get('chat_placeholder', locale),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Color(0xFFFFB4C8).withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: _isSending
                ? Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                : IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    _messageController.clear();
    setState(() => _isSending = true);

    await _coachService.sendMessage(message);
    
    if (mounted) {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }
}
