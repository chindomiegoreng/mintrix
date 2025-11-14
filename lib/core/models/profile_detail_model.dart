class ProfileDetailModel {
  final UserDetailModel user;
  final StatsDetailModel stats;
  final PersonalityDetailModel personality;

  ProfileDetailModel({
    required this.user,
    required this.stats,
    required this.personality,
  });

  factory ProfileDetailModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailModel(
      user: UserDetailModel.fromJson(json['user'] ?? {}),
      stats: StatsDetailModel.fromJson(json['stats'] ?? {}),
      personality: PersonalityDetailModel.fromJson(json['personality'] ?? {}),
    );
  }
}

class UserDetailModel {
  final String id;
  final String nama;
  final String email;
  final bool personalization;
  final String? foto;

  UserDetailModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.personalization,
    this.foto,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['_id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      personalization: json['personalization'] ?? false,
      foto: json['foto'],
    );
  }
}

class StatsDetailModel {
  final String id;
  final String userId;
  final bool streakActive;
  final int streakCount;
  final int point;
  final int xp;
  final String liga;

  StatsDetailModel({
    required this.id,
    required this.userId,
    required this.streakActive,
    required this.streakCount,
    required this.point,
    required this.xp,
    required this.liga,
  });

  factory StatsDetailModel.fromJson(Map<String, dynamic> json) {
    return StatsDetailModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      streakActive: json['streakActive'] ?? false,
      streakCount: json['streakCount'] ?? 0,
      point: json['point'] ?? 0,
      xp: json['xp'] ?? 0,
      liga: json['liga'] ?? 'Bronze',
    );
  }
}

class PersonalityDetailModel {
  final String id;
  final String userId;
  final int kreatifitas;
  final int keberanian;
  final int empati;
  final int kerjaSama;
  final int tanggungJawab;
  final String hobiDanMinat;

  PersonalityDetailModel({
    required this.id,
    required this.userId,
    required this.kreatifitas,
    required this.keberanian,
    required this.empati,
    required this.kerjaSama,
    required this.tanggungJawab,
    required this.hobiDanMinat,
  });

  factory PersonalityDetailModel.fromJson(Map<String, dynamic> json) {
    return PersonalityDetailModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      kreatifitas: json['kreatifitas'] ?? 0,
      keberanian: json['keberanian'] ?? 0,
      empati: json['empati'] ?? 0,
      kerjaSama: json['kerjaSama'] ?? 0,
      tanggungJawab: json['tanggungJawab'] ?? 0,
      hobiDanMinat: json['hobiDanMinat'] ?? '',
    );
  }

  // Convert to radar chart values (0-1 scale)
  List<double> toRadarValues() {
    return [
      keberanian / 100.0, // Berani
      empati / 100.0, // Empati
      tanggungJawab / 100.0, // Tanggung Jawab
      kerjaSama / 100.0, // Kerja Sama
      kreatifitas / 100.0, // Kreativitas
    ];
  }
}
