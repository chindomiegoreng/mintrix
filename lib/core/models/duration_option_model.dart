class DurationOptionModel {
  final String id;
  final int duration;
  final String title;
  final String subtitle;
  final String? icon;

  DurationOptionModel({
    required this.id,
    required this.duration,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  // Dari JSON ke Object (untuk data dari API)
  factory DurationOptionModel.fromJson(Map<String, dynamic> json) {
    return DurationOptionModel(
      id: json['id'] ?? json['_id'] ?? '',
      duration: json['duration'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? json['description'] ?? '',
      icon: json['icon'],
    );
  }

  // Dari Object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DurationOptionModel &&
        other.id == id &&
        other.duration == duration;
  }

  @override
  int get hashCode => id.hashCode ^ duration.hashCode;
}