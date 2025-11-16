class CVModel {
  final String? id;
  final String userId;
  final CVKontak kontak;
  final List<CVPengalaman> pengalaman;
  final List<CVPendidikan> pendidikan;
  final List<CVKeterampilan> keterampilan;
  final List<CVBahasa> bahasa;
  final List<CVSertifikasi> sertifikasiDanLisensi;
  final List<CVPenghargaan> penghargaanDanApresiasi;
  final List<CVMediaSosial> situsWebDanMediaSosial;
  final List<CVKustom>? kustom;
  final String ringkasan;
  final String? resumeLink;

  CVModel({
    this.id,
    required this.userId,
    required this.kontak,
    required this.pengalaman,
    required this.pendidikan,
    required this.keterampilan,
    required this.bahasa,
    required this.sertifikasiDanLisensi,
    required this.penghargaanDanApresiasi,
    required this.situsWebDanMediaSosial,
    this.kustom,
    required this.ringkasan,
    this.resumeLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'kontak': kontak.toJson(),
      'pengalaman': pengalaman.map((e) => e.toJson()).toList(),
      'pendidikan': pendidikan.map((e) => e.toJson()).toList(),
      'keterampilan': keterampilan.map((e) => e.toJson()).toList(),
      'bahasa': bahasa.map((e) => e.toJson()).toList(),
      'sertifikasiDanLisensi': sertifikasiDanLisensi.map((e) => e.toJson()).toList(),
      'penghargaanDanApresiasi': penghargaanDanApresiasi.map((e) => e.toJson()).toList(),
      'situsWebDanMediaSosial': situsWebDanMediaSosial.map((e) => e.toJson()).toList(),
      if (kustom != null) 'kustom': kustom!.map((e) => e.toJson()).toList(),
      'ringkasan': ringkasan,
    };
  }

  factory CVModel.fromJson(Map<String, dynamic> json) {
    return CVModel(
      id: json['_id'],
      userId: json['userId'],
      kontak: CVKontak.fromJson(json['kontak']),
      pengalaman: (json['pengalaman'] as List?)
              ?.map((e) => CVPengalaman.fromJson(e))
              .toList() ??
          [],
      pendidikan: (json['pendidikan'] as List?)
              ?.map((e) => CVPendidikan.fromJson(e))
              .toList() ??
          [],
      keterampilan: (json['keterampilan'] as List?)
              ?.map((e) => CVKeterampilan.fromJson(e))
              .toList() ??
          [],
      bahasa: (json['bahasa'] as List?)
              ?.map((e) => CVBahasa.fromJson(e))
              .toList() ??
          [],
      sertifikasiDanLisensi: (json['sertifikasiDanLisensi'] as List?)
              ?.map((e) => CVSertifikasi.fromJson(e))
              .toList() ??
          [],
      penghargaanDanApresiasi: (json['penghargaanDanApresiasi'] as List?)
              ?.map((e) => CVPenghargaan.fromJson(e))
              .toList() ??
          [],
      situsWebDanMediaSosial: (json['situsWebDanMediaSosial'] as List?)
              ?.map((e) => CVMediaSosial.fromJson(e))
              .toList() ??
          [],
      kustom: (json['kustom'] as List?)
          ?.map((e) => CVKustom.fromJson(e))
          .toList(),
      ringkasan: json['ringkasan'] ?? '',
      resumeLink: json['resumeLink'],
    );
  }
}

class CVKontak {
  final String namaAwal;
  final String namaAkhir;
  final String jabatanYangDiinginkan;
  final String nomorTelepon;
  final String email;
  final String negara;
  final String kota;
  final String alamatLengkap;

  CVKontak({
    required this.namaAwal,
    required this.namaAkhir,
    required this.jabatanYangDiinginkan,
    required this.nomorTelepon,
    required this.email,
    required this.negara,
    required this.kota,
    required this.alamatLengkap,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaAwal': namaAwal,
      'namaAkhir': namaAkhir,
      'jabatanYangDiinginkan': jabatanYangDiinginkan,
      'nomorTelepon': nomorTelepon,
      'email': email,
      'negara': negara,
      'kota': kota,
      'alamatLengkap': alamatLengkap,
    };
  }

  factory CVKontak.fromJson(Map<String, dynamic> json) {
    return CVKontak(
      namaAwal: json['namaAwal'] ?? '',
      namaAkhir: json['namaAkhir'] ?? '',
      jabatanYangDiinginkan: json['jabatanYangDiinginkan'] ?? '',
      nomorTelepon: json['nomorTelepon'] ?? '',
      email: json['email'] ?? '',
      negara: json['negara'] ?? '',
      kota: json['kota'] ?? '',
      alamatLengkap: json['alamatLengkap'] ?? '',
    );
  }
}

class CVPengalaman {
  final String jabatan;
  final String perusahaan;
  final String lokasi;
  final String tanggalMulai;
  final String? tanggalSelesai;
  final String deskripsi;

  CVPengalaman({
    required this.jabatan,
    required this.perusahaan,
    required this.lokasi,
    required this.tanggalMulai,
    this.tanggalSelesai,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    return {
      'jabatan': jabatan,
      'perusahaan': perusahaan,
      'lokasi': lokasi,
      'tanggalMulai': tanggalMulai,
      if (tanggalSelesai != null && tanggalSelesai!.isNotEmpty)
        'tanggalSelesai': tanggalSelesai,
      'deskripsi': deskripsi,
    };
  }

  factory CVPengalaman.fromJson(Map<String, dynamic> json) {
    return CVPengalaman(
      jabatan: json['jabatan'] ?? '',
      perusahaan: json['perusahaan'] ?? '',
      lokasi: json['lokasi'] ?? '',
      tanggalMulai: json['tanggalMulai'] ?? '',
      tanggalSelesai: json['tanggalSelesai'],
      deskripsi: json['deskripsi'] ?? '',
    );
  }
}

class CVPendidikan {
  final String namaSekolah;
  final String lokasi;
  final String penjurusan;
  final String tanggalMulai;
  final String? tanggalSelesai;
  final String deskripsi;

  CVPendidikan({
    required this.namaSekolah,
    required this.lokasi,
    required this.penjurusan,
    required this.tanggalMulai,
    this.tanggalSelesai,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaSekolah': namaSekolah,
      'lokasi': lokasi,
      'penjurusan': penjurusan,
      'tanggalMulai': tanggalMulai,
      if (tanggalSelesai != null && tanggalSelesai!.isNotEmpty)
        'tanggalSelesai': tanggalSelesai,
      'deskripsi': deskripsi,
    };
  }

  factory CVPendidikan.fromJson(Map<String, dynamic> json) {
    return CVPendidikan(
      namaSekolah: json['namaSekolah'] ?? '',
      lokasi: json['lokasi'] ?? '',
      penjurusan: json['penjurusan'] ?? '',
      tanggalMulai: json['tanggalMulai'] ?? '',
      tanggalSelesai: json['tanggalSelesai'],
      deskripsi: json['deskripsi'] ?? '',
    );
  }
}

class CVKeterampilan {
  final String namaKeterampilan;
  final int level;

  CVKeterampilan({
    required this.namaKeterampilan,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaKeterampilan': namaKeterampilan,
      'level': level,
    };
  }

  factory CVKeterampilan.fromJson(Map<String, dynamic> json) {
    return CVKeterampilan(
      namaKeterampilan: json['namaKeterampilan'] ?? '',
      level: json['level'] ?? 1,
    );
  }
}

class CVBahasa {
  final String namaBahasa;
  final int level;

  CVBahasa({
    required this.namaBahasa,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaBahasa': namaBahasa,
      'level': level,
    };
  }

  factory CVBahasa.fromJson(Map<String, dynamic> json) {
    return CVBahasa(
      namaBahasa: json['namaBahasa'] ?? '',
      level: json['level'] ?? 1,
    );
  }
}

class CVSertifikasi {
  final String namaSertifikasi;

  CVSertifikasi({required this.namaSertifikasi});

  Map<String, dynamic> toJson() {
    return {'namaSertifikasi': namaSertifikasi};
  }

  factory CVSertifikasi.fromJson(Map<String, dynamic> json) {
    return CVSertifikasi(
      namaSertifikasi: json['namaSertifikasi'] ?? '',
    );
  }
}

class CVPenghargaan {
  final String namaPenghargaan;
  final String? deskripsi;

  CVPenghargaan({
    required this.namaPenghargaan,
    this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaPenghargaan': namaPenghargaan,
      if (deskripsi != null && deskripsi!.isNotEmpty) 'deskripsi': deskripsi,
    };
  }

  factory CVPenghargaan.fromJson(Map<String, dynamic> json) {
    return CVPenghargaan(
      namaPenghargaan: json['namaPenghargaan'] ?? '',
      deskripsi: json['deskripsi'],
    );
  }
}

class CVMediaSosial {
  final String namaMediaSosial;
  final String linkMediaSosial;

  CVMediaSosial({
    required this.namaMediaSosial,
    required this.linkMediaSosial,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaMediaSosial': namaMediaSosial,
      'linkMediaSosial': linkMediaSosial,
    };
  }

  factory CVMediaSosial.fromJson(Map<String, dynamic> json) {
    return CVMediaSosial(
      namaMediaSosial: json['namaMediaSosial'] ?? '',
      linkMediaSosial: json['linkMediaSosial'] ?? '',
    );
  }
}

class CVKustom {
  final String teksKustom;

  CVKustom({required this.teksKustom});

  Map<String, dynamic> toJson() {
    return {'teksKustom': teksKustom};
  }

  factory CVKustom.fromJson(Map<String, dynamic> json) {
    return CVKustom(
      teksKustom: json['teksKustom'] ?? '',
    );
  }
}