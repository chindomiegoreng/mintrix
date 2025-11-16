class ChatTitleModel {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatTitleModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatTitleModel.fromJson(Map<String, dynamic> json) {
    return ChatTitleModel(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ChatHistoryModel {
  final String id;
  final String titleId;
  final DateTime createdAt;
  final List<ChatMessageModel> messages;
  final DateTime updatedAt;

  ChatHistoryModel({
    required this.id,
    required this.titleId,
    required this.createdAt,
    required this.messages,
    required this.updatedAt,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      id: json['_id'],
      titleId: json['titleId'],
      createdAt: DateTime.parse(json['createdAt']),
      messages: (json['messages'] as List)
          .map((m) => ChatMessageModel.fromJson(m))
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ChatMessageModel {
  final String role;
  final String content;

  ChatMessageModel({
    required this.role,
    required this.content,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}
