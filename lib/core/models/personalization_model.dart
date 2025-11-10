class PersonalizationModel {
  final String userId;
  final String waktuBelajar;
  final List<String> kekurangan;
  final List<String> kelebihan;
  final String ceritaSingkat;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PersonalizationModel({
    required this.userId,
    required this.waktuBelajar,
    required this.kekurangan,
    required this.kelebihan,
    required this.ceritaSingkat,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  // Dari JSON ke Object
  factory PersonalizationModel.fromJson(Map<String, dynamic> json) {
    return PersonalizationModel(
      userId: json['userId'] ?? '',
      waktuBelajar: json['waktuBelajar'] ?? '',
      kekurangan: List<String>.from(json['kekurangan'] ?? []),
      kelebihan: List<String>.from(json['kelebihan'] ?? []),
      ceritaSingkat: json['ceritaSingkat'] ?? '',
      id: json['_id'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Dari Object ke JSON (untuk POST)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'waktuBelajar': waktuBelajar,
      'kekurangan': kekurangan,
      'kelebihan': kelebihan,
      'ceritaSingkat': ceritaSingkat,
      if (id != null) '_id': id,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // Helper untuk display
  String getFormattedCreatedAt() {
    if (createdAt == null) return '-';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }
}
