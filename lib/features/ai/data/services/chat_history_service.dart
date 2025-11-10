import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/chat_history.dart';

class ChatHistoryService {
  static const String _historyBoxName = 'chat_history';
  static const String _settingsBoxName = 'chat_settings';
  static const String _lastClearDateKey = 'last_clear_date';

  late Box<ChatHistory> _historyBox;
  late Box _settingsBox;

  Future<void> init() async {
    _historyBox = await Hive.openBox<ChatHistory>(_historyBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  Future<void> saveCurrentChat(List<dynamic> messages) async {
    if (messages.isEmpty || messages.length <= 1) return;

    await init();
    final today = DateTime.now();

    // Create chat session
    final chatSession = ChatHistory(
      id: today.millisecondsSinceEpoch.toString(),
      title: _generateTitle(messages),
      messages: messages
          .map(
            (msg) => {
              'text': msg.text,
              'isFromDino': msg.isFromDino,
              'time': msg.time,
            },
          )
          .toList(),
      date: today,
    );

    // Save to Hive
    await _historyBox.put(chatSession.id, chatSession);

    // Keep only last 50 sessions
    if (_historyBox.length > 50) {
      final oldestKeys = _historyBox.keys.take(_historyBox.length - 50);
      for (final key in oldestKeys) {
        await _historyBox.delete(key);
      }
    }
  }

  Future<List<ChatHistory>> getChatHistory() async {
    await init();
    final histories = _historyBox.values.toList();
    histories.sort((a, b) => b.date.compareTo(a.date));
    return histories;
  }

  Future<bool> shouldClearToday() async {
    await init();
    final lastClearString = _settingsBox.get(_lastClearDateKey);

    if (lastClearString == null) return false;

    final lastClearDate = DateTime.parse(lastClearString);
    final today = DateTime.now();

    return today.day != lastClearDate.day ||
        today.month != lastClearDate.month ||
        today.year != lastClearDate.year;
  }

  Future<void> markClearedToday() async {
    await init();
    await _settingsBox.put(_lastClearDateKey, DateTime.now().toIso8601String());
  }

  String _generateTitle(List<dynamic> messages) {
    if (messages.isEmpty) return 'Chat kosong';

    final firstUserMessage = messages.firstWhere(
      (msg) => !msg.isFromDino,
      orElse: () => null,
    );

    if (firstUserMessage != null) {
      String text = firstUserMessage.text as String;
      return text.length > 30 ? '${text.substring(0, 30)}...' : text;
    }

    return 'Chat dengan Dino';
  }
}
