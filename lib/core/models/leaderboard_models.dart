class LeaderboardUser {
  final String nama;
  final String? foto;
  final int xp;

  LeaderboardUser({
    required this.nama,
    required this.foto,
    required this.xp,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      nama: json['nama'] ?? 'Unknown',
      foto: json['foto'],
      xp: json['xp'] ?? 0,
    );
  }
}