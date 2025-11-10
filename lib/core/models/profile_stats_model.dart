class ProfileStatsModel {
  final String id;
  final String userId;
  final bool streakActive;
  final int streakCount;
  final int point;
  final int xp;
  final String liga;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileStatsModel({
    required this.id,
    required this.userId,
    required this.streakActive,
    required this.streakCount,
    required this.point,
    required this.xp,
    required this.liga,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileStatsModel.fromJson(Map<String, dynamic> json) {
    return ProfileStatsModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      streakActive: json['streakActive'] ?? false,
      streakCount: json['streakCount'] ?? 0,
      point: json['point'] ?? 0,
      xp: json['xp'] ?? 0,
      liga: json['liga'] ?? 'Bronze',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'streakActive': streakActive,
      'streakCount': streakCount,
      'point': point,
      'xp': xp,
      'liga': liga,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
