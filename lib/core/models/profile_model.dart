class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? foto;
  final bool? personalization; // ✅ Changed from String? to bool?
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Stats (akan diambil dari endpoint terpisah nanti)
  final String? liga;
  final int totalXp;
  final int runtutan;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.foto,
    this.personalization, // ✅ bool type
    this.createdAt,
    this.updatedAt,
    this.liga,
    this.totalXp = 0,
    this.runtutan = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['nama'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      foto: json['foto'],
      personalization: json['personalization'] as bool?, // ✅ Cast to bool
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      liga: json['liga'] ?? 'Bronze',
      totalXp: json['totalXp'] ?? json['xp'] ?? 0,
      runtutan: json['runtutan'] ?? json['streak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nama': name,
      'email': email,
      'foto': foto,
      'personalization': personalization, // ✅ bool type
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'liga': liga,
      'totalXp': totalXp,
      'runtutan': runtutan,
    };
  }
}
