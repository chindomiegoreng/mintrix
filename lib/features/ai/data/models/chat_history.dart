import 'package:hive/hive.dart';

part 'chat_history.g.dart';

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<Map<String, dynamic>> messages;

  @HiveField(3)
  DateTime date;

  ChatHistory({
    required this.id,
    required this.title,
    required this.messages,
    required this.date,
  });

  // Empty constructor for Hive
  ChatHistory.empty()
    : id = '',
      title = '',
      messages = [],
      date = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages,
      'date': date.toIso8601String(),
    };
  }

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      messages: List<Map<String, dynamic>>.from(json['messages'] ?? []),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Kemarin';
    } else if (difference < 7) {
      return '$difference hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  int get progressPercentage {
    if (messages.isEmpty) return 0;
    final userMessages = messages.where((m) => !m['isFromDino']).length;
    return (userMessages * 10).clamp(0, 100);
  }
}
