import 'package:flutter/material.dart';
import 'package:mintrix/features/ai/presentation/pages/ai_history_page.dart';
import 'package:mintrix/features/ai/data/services/ai_service.dart';
import 'package:mintrix/features/ai/data/services/chat_history_service.dart';
import 'package:mintrix/shared/theme.dart';

class AIPage extends StatefulWidget {
  final bool showAppBar;

  const AIPage({super.key, this.showAppBar = true});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final TextEditingController _messageController = TextEditingController();
  final AIService _aiService = AIService();
  final ChatHistoryService _historyService = ChatHistoryService();
  bool _isLoading = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Halo! Saya Dino, asisten pintar dari Aplikasi Mintrix. Ada yang bisa saya bantu hari ini?",
      isFromDino: true,
      time: "10:30",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkAndClearMessages();
  }

  Future<void> _checkAndClearMessages() async {
    final shouldClear = await _historyService.shouldClearToday();

    if (shouldClear && _messages.length > 1) {
      // Save current chat before clearing
      await _historyService.saveCurrentChat(_messages);

      // Clear messages except the initial greeting
      setState(() {
        _messages.removeRange(1, _messages.length);
      });

      await _historyService.markClearedToday();
    }
  }

  @override
  void dispose() {
    // Save chat before disposing
    if (_messages.length > 1) {
      _historyService.saveCurrentChat(_messages);
    }
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    final currentTime = TimeOfDay.now().format(context);

    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isFromDino: false, time: currentTime),
      );
      _isLoading = true;
    });

    _messageController.clear();

    try {
      // Prepare messages for API
      final apiMessages = _messages
          .map(
            (msg) => {
              'role': msg.isFromDino ? 'assistant' : 'user',
              'content': msg.text,
            },
          )
          .toList();

      final response = await _aiService.sendMessage(apiMessages);

      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isFromDino: true,
            time: TimeOfDay.now().format(context),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Maaf, terjadi kesalahan. Coba lagi nanti ya.",
            isFromDino: true,
            time: TimeOfDay.now().format(context),
          ),
        );
        _isLoading = false;
      });
    }
  }

  void _startNewChat() async {
    // Save current chat before starting new one
    if (_messages.length > 1) {
      await _historyService.saveCurrentChat(_messages);
    }

    // Reset to initial state
    setState(() {
      _messages.clear();
      _messages.add(
        ChatMessage(
          text:
              "Halo! Saya Dino, asisten pintar dari Aplikasi Mintrix. Ada yang bisa saya bantu hari ini?",
          isFromDino: true,
          time: TimeOfDay.now().format(context),
        ),
      );
      _isLoading = false;
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.showAppBar
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () async {
                  // Save chat before closing
                  if (_messages.length > 1) {
                    await _historyService.saveCurrentChat(_messages);
                  }
                  Navigator.pop(context);
                },
              )
            : null,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xffE1F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Dino",
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: _startNewChat,
            tooltip: 'Chat Baru',
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () async {
              // Save current chat before navigating
              if (_messages.length > 1) {
                await _historyService.saveCurrentChat(_messages);
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIHistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildLoadingBubble();
                }
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: "Tulis Pesan",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[400],
                              size: 24,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xff4DD4E8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xffE1F5F5),
            child: Image.asset(
              'assets/images/dino_get_started.png',
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xff4DD4E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Dino sedang mengetik...",
                  style: primaryTextStyle.copyWith(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isFromDino
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isFromDino) ...[
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xffE1F5F5),
              child: Image.asset(
                'assets/images/dino_get_started.png',
                width: 30,
                height: 30,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromDino
                    ? const Color(0xff4DD4E8)
                    : const Color(0xffF0F0F0),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isFromDino
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                  bottomRight: message.isFromDino
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                ),
              ),
              child: Text(
                message.text,
                style: primaryTextStyle.copyWith(
                  fontSize: 14,
                  color: message.isFromDino ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (!message.isFromDino) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xffF0F0F0),
              child: Icon(Icons.person, color: Colors.grey[600], size: 24),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isFromDino;
  final String time;

  ChatMessage({
    required this.text,
    required this.isFromDino,
    required this.time,
  });
}
