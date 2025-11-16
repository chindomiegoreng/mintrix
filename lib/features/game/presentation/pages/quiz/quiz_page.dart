import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/services/streak_service.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_event.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/shared/theme.dart';

class QuizPage extends StatefulWidget {
  final String moduleId;
  final String sectionId;
  final String subSection;
  final int xpReward; // ✅ Add XP reward parameter

  const QuizPage({
    super.key,
    required this.moduleId,
    required this.sectionId,
    required this.subSection,
    this.xpReward = 80, // ✅ Default 80 XP
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int correctAnswers = 0;
  bool showResult = false;
  final ApiClient _apiClient = ApiClient();
  final StreakService _streakService = StreakService();
  bool _isSubmittingXP = false;

  List<Map<String, dynamic>> _getQuestions() {
    // 🎯 CARD 1: Mencari Hal Yang Kamu Suka - Quiz 1
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka_quiz1") {
      return [
        {
          "question": "Apa yang dimaksud dengan minat?",
          "options": [
            "Hal yang membuatmu penasaran dan ingin kamu pelajari",
            "Hal yang membuatmu terpaksa untuk lakukan",
            "Hal yang kamu abaikan",
            "Hal yang tidak kamu sukai",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Mengapa penting untuk mengenal minat diri sendiri?",
          "options": [
            "Agar dapat memilih karir yang sesuai",
            "Untuk mengikuti tren terkini",
            "Supaya terlihat lebih pintar",
            "Karena diwajibkan oleh orang tua",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Bagaimana cara menemukan minat yang sebenarnya?",
          "options": [
            "Mengikuti minat orang lain",
            "Mencoba berbagai hal dan merefleksikan perasaan",
            "Menunggu sampai ada yang memberitahu",
            "Memilih yang paling mudah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa hubungan antara minat dan motivasi?",
          "options": [
            "Tidak ada hubungan",
            "Minat meningkatkan motivasi untuk belajar",
            "Motivasi menghilangkan minat",
            "Keduanya bertolak belakang",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Jika kamu suka menggambar, bidang apa yang cocok?",
          "options": [
            "Akuntansi",
            "Desain grafis atau seni rupa",
            "Teknik mesin",
            "Farmasi",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang harus dilakukan jika belum menemukan minat?",
          "options": [
            "Berhenti mencari dan menyerah",
            "Terus eksplorasi dan mencoba hal baru",
            "Mengikuti apa kata orang lain saja",
            "Memaksakan diri pada satu bidang",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 1: Mencari Hal Yang Kamu Suka - Quiz 2 (Eksplorasi Diri)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka_quiz2") {
      return [
        {
          "question":
              "Apa yang dimaksud dengan self-awareness (kesadaran diri)?",
          "options": [
            "Kemampuan memahami kekuatan dan kelemahan diri",
            "Selalu memikirkan pendapat orang lain",
            "Mengabaikan perasaan sendiri",
            "Tidak pernah melakukan refleksi diri",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Bagaimana cara mengidentifikasi kelebihan diri?",
          "options": [
            "Meminta orang lain menilai diri kita",
            "Mengingat momen saat merasa paling bangga",
            "Membandingkan dengan orang lain",
            "Fokus hanya pada kelemahan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran passion dalam memilih karir?",
          "options": [
            "Tidak berperan sama sekali",
            "Membuat pekerjaan terasa lebih bermakna",
            "Hanya untuk hobi, bukan karir",
            "Passion tidak penting dalam karir",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Bagaimana mengenali aktivitas yang sesuai dengan minatmu?",
          "options": [
            "Aktivitas yang membuatmu lupa waktu",
            "Aktivitas yang paling mudah dilakukan",
            "Aktivitas yang dilakukan orang lain",
            "Aktivitas dengan bayaran tertinggi",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Apa yang sebaiknya dilakukan saat minat berubah?",
          "options": [
            "Panik dan bingung",
            "Eksplorasi minat baru dengan terbuka",
            "Memaksakan minat lama",
            "Berhenti mencari minat",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa refleksi diri penting dalam menemukan minat?",
          "options": [
            "Tidak penting sama sekali",
            "Membantu memahami apa yang benar-benar disukai",
            "Hanya membuang waktu",
            "Membuat bingung",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 1: Mencari Hal Yang Kamu Suka - Quiz 3 (Menemukan Passion)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka_quiz3") {
      return [
        {
          "question": "Apa perbedaan antara hobi dan passion?",
          "options": [
            "Tidak ada perbedaan",
            "Passion lebih mendalam dan bisa jadi karir",
            "Hobi lebih penting dari passion",
            "Passion hanya untuk anak muda",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara mengubah minat menjadi keahlian?",
          "options": [
            "Hanya bermimpi tanpa tindakan",
            "Latihan konsisten dan belajar berkelanjutan",
            "Menunggu bakat muncul sendiri",
            "Tidak perlu usaha keras",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Apa yang harus dilakukan jika passion tidak menghasilkan uang?",
          "options": [
            "Langsung menyerah",
            "Cari cara kreatif untuk monetisasi",
            "Passion tidak untuk menghasilkan uang",
            "Ganti passion lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa penting mengejar passion dalam hidup?",
          "options": [
            "Tidak penting, fokus pada uang saja",
            "Membuat hidup lebih bermakna dan bahagia",
            "Hanya untuk pamer di media sosial",
            "Passion tidak ada hubungannya dengan kebahagiaan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa tanda bahwa kamu telah menemukan passion sejati?",
          "options": [
            "Merasa terpaksa melakukannya",
            "Bersemangat dan termotivasi tanpa dipaksa",
            "Hanya dilakukan saat ada hadiah",
            "Cepat bosan dan ingin berhenti",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana sikap yang tepat dalam mengembangkan minat?",
          "options": [
            "Menyerah saat ada kesulitan",
            "Tetap konsisten meski ada tantangan",
            "Hanya melakukan saat mood bagus",
            "Berpindah-pindah minat setiap hari",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 2: Mengatur Waktu - Quiz 1
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengatur_waktu_quiz1") {
      return [
        {
          "question": "Apa manfaat utama mengatur waktu dengan baik?",
          "options": [
            "Membuat hidup lebih teratur dan produktif",
            "Agar terlihat sibuk",
            "Supaya tidak punya waktu luang",
            "Untuk menghindari tanggung jawab",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Teknik manajemen waktu yang populer adalah?",
          "options": [
            "Menunda semua pekerjaan",
            "Pomodoro Technique",
            "Bekerja tanpa istirahat",
            "Multitasking ekstrem",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Apa yang dimaksud dengan prioritas dalam mengatur waktu?",
          "options": [
            "Mengerjakan semua tugas bersamaan",
            "Menentukan tugas mana yang paling penting",
            "Mengabaikan tugas yang sulit",
            "Hanya fokus pada hal yang disukai",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara mengatasi prokrastinasi?",
          "options": [
            "Menunda lebih lama lagi",
            "Membagi tugas besar menjadi bagian kecil",
            "Menunggu deadline",
            "Menyalahkan orang lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu time blocking?",
          "options": [
            "Memblokir semua aktivitas",
            "Mengalokasikan waktu khusus untuk tugas tertentu",
            "Menghindari jadwal",
            "Bekerja sepanjang hari",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa penting untuk memiliki waktu istirahat?",
          "options": [
            "Tidak penting sama sekali",
            "Untuk menjaga produktivitas dan kesehatan mental",
            "Hanya untuk orang malas",
            "Agar bisa menonton TV",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 2: Mengatur Waktu - Quiz 2 (Prioritas Tugas)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengatur_waktu_quiz2") {
      return [
        {
          "question": "Apa itu Matriks Eisenhower?",
          "options": [
            "Alat untuk menentukan prioritas berdasarkan urgensi dan penting",
            "Aplikasi untuk menghitung waktu",
            "Metode untuk menunda pekerjaan",
            "Teknik multitasking",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Tugas yang penting tapi tidak mendesak sebaiknya?",
          "options": [
            "Diabaikan saja",
            "Dijadwalkan dengan baik",
            "Dikerjakan kapan saja",
            "Didelegasikan ke orang lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang dimaksud dengan 'eat the frog'?",
          "options": [
            "Makan kodok sungguhan",
            "Mengerjakan tugas tersulit terlebih dahulu",
            "Menghindari tugas sulit",
            "Mengerjakan tugas mudah dulu",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana menentukan tugas yang benar-benar penting?",
          "options": [
            "Semua tugas sama pentingnya",
            "Sesuaikan dengan tujuan jangka panjang",
            "Yang paling mudah adalah yang penting",
            "Yang diminta orang lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa dampak tidak memprioritaskan tugas?",
          "options": [
            "Semua berjalan lancar",
            "Waktu terbuang untuk hal tidak penting",
            "Menjadi lebih produktif",
            "Tidak ada dampak negatif",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Kapan sebaiknya mengerjakan tugas yang paling penting?",
          "options": [
            "Malam hari saat lelah",
            "Pagi hari saat energi penuh",
            "Kapan saja tidak masalah",
            "Saat deadline mendekat",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 2: Mengatur Waktu - Quiz 3 (Produktivitas)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengatur_waktu_quiz3") {
      return [
        {
          "question": "Apa itu deep work?",
          "options": [
            "Bekerja di laut dalam",
            "Fokus penuh tanpa distraksi untuk hasil maksimal",
            "Bekerja sambil bermain",
            "Multitasking ekstrem",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Berapa lama ideal untuk satu sesi Pomodoro?",
          "options": ["5 menit", "25 menit", "2 jam", "Sepanjang hari"],
          "correctAnswer": 1,
        },
        {
          "question": "Apa musuh terbesar produktivitas?",
          "options": [
            "Istirahat",
            "Distraksi dan prokrastinasi",
            "Perencanaan",
            "Fokus",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara menghindari burnout?",
          "options": [
            "Bekerja terus tanpa istirahat",
            "Seimbangkan kerja dan istirahat",
            "Hindari semua pekerjaan",
            "Bekerja hanya saat mood bagus",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu batch processing dalam manajemen waktu?",
          "options": [
            "Menunda semua tugas",
            "Mengelompokkan tugas serupa dan mengerjakan bersamaan",
            "Mengerjakan satu per satu dengan lambat",
            "Membagi tugas ke banyak orang",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa to-do list penting untuk produktivitas?",
          "options": [
            "Tidak penting sama sekali",
            "Membantu mengingat dan melacak tugas",
            "Hanya untuk gaya-gayaan",
            "Membuat bingung",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 3: Berpikir Positif - Quiz 1
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "berpikir_positif_quiz1") {
      return [
        {
          "question": "Apa yang dimaksud dengan berpikir positif?",
          "options": [
            "Mengabaikan semua masalah",
            "Melihat sisi baik dari setiap situasi",
            "Selalu tersenyum tanpa alasan",
            "Tidak peduli dengan kenyataan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana berpikir positif mempengaruhi kesuksesan?",
          "options": [
            "Tidak ada pengaruh",
            "Meningkatkan motivasi dan resiliensi",
            "Membuat orang menjadi naif",
            "Menghilangkan semua tantangan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang harus dilakukan saat menghadapi kegagalan?",
          "options": [
            "Menyerah dan tidak mencoba lagi",
            "Belajar dari kesalahan dan mencoba lagi",
            "Menyalahkan orang lain",
            "Menghindari tantangan di masa depan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu self-talk positif?",
          "options": [
            "Berbicara dengan orang lain",
            "Memberi dukungan pada diri sendiri lewat kata-kata",
            "Mengkritik diri sendiri",
            "Berbicara keras di depan umum",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Bagaimana gratitude (rasa syukur) membantu pola pikir positif?",
          "options": [
            "Tidak membantu sama sekali",
            "Membuat kita fokus pada hal baik yang dimiliki",
            "Membuat kita berhenti berkembang",
            "Hanya untuk orang religius",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa cara praktis untuk melatih berpikir positif?",
          "options": [
            "Menghindari semua orang negatif",
            "Menulis jurnal syukur setiap hari",
            "Tidak pernah merasakan emosi negatif",
            "Pura-pura bahagia",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 3: Berpikir Positif - Quiz 2 (Mindset Growth)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "berpikir_positif_quiz2") {
      return [
        {
          "question": "Apa itu growth mindset?",
          "options": [
            "Pola pikir bahwa kemampuan bisa dikembangkan",
            "Percaya kemampuan sudah tetap sejak lahir",
            "Tidak mau belajar hal baru",
            "Menyerah saat ada kesulitan",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Apa lawan dari growth mindset?",
          "options": [
            "Positive mindset",
            "Fixed mindset",
            "Open mindset",
            "Creative mindset",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Bagaimana orang dengan growth mindset melihat kegagalan?",
          "options": [
            "Sebagai akhir dari segalanya",
            "Sebagai kesempatan untuk belajar",
            "Sebagai bukti ketidakmampuan",
            "Sebagai alasan untuk menyerah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa manfaat memiliki growth mindset?",
          "options": [
            "Tidak ada manfaatnya",
            "Lebih berani mengambil tantangan baru",
            "Membuat takut gagal",
            "Membatasi potensi diri",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Bagaimana cara mengubah fixed mindset menjadi growth mindset?",
          "options": [
            "Tidak bisa diubah",
            "Latihan dan kesadaran diri konsisten",
            "Menunggu perubahan datang sendiri",
            "Mengabaikan feedback",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa kata kunci growth mindset?",
          "options": [
            "Saya tidak bisa",
            "Saya belum bisa, tapi saya bisa belajar",
            "Ini terlalu sulit",
            "Saya menyerah",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 3: Berpikir Positif - Quiz 3 (Resiliensi Mental)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "berpikir_positif_quiz3") {
      return [
        {
          "question": "Apa yang dimaksud dengan resiliensi mental?",
          "options": [
            "Kemampuan untuk tidak pernah mengalami masalah",
            "Kemampuan bangkit dari kesulitan",
            "Mengabaikan semua masalah",
            "Menyerah pada tekanan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana membangun resiliensi mental?",
          "options": [
            "Menghindari semua tantangan",
            "Menghadapi dan belajar dari kesulitan",
            "Menyalahkan orang lain",
            "Tidak pernah keluar dari zona nyaman",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran support system dalam resiliensi?",
          "options": [
            "Tidak berperan sama sekali",
            "Memberikan dukungan saat menghadapi kesulitan",
            "Membuat lemah",
            "Tidak penting",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana menghadapi kritik dengan resiliensi?",
          "options": [
            "Marah dan defensif",
            "Terima sebagai pembelajaran dan perbaiki diri",
            "Abaikan semua kritik",
            "Menyalahkan pemberi kritik",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa tanda orang yang memiliki resiliensi tinggi?",
          "options": [
            "Mudah menyerah",
            "Cepat bangkit setelah kegagalan",
            "Menghindari tantangan",
            "Tidak pernah gagal",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa self-care penting untuk resiliensi?",
          "options": [
            "Tidak ada hubungannya",
            "Menjaga kesehatan fisik dan mental untuk menghadapi tantangan",
            "Hanya untuk orang lemah",
            "Membuang waktu",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 1: Mencari Hal Yang Kamu Suka - Quiz 4 (Potensi Diri)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka_quiz4") {
      return [
        {
          "question": "Apa yang dimaksud dengan potensi diri?",
          "options": [
            "Kemampuan yang sudah sempurna",
            "Kemampuan yang dapat dikembangkan",
            "Hanya bakat bawaan lahir",
            "Tidak bisa diubah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara menggali potensi diri?",
          "options": [
            "Menunggu orang lain memberitahu",
            "Mencoba berbagai hal dan mengamati respons diri",
            "Tidak perlu digali",
            "Hanya fokus pada satu bidang",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran mentor dalam mengembangkan potensi?",
          "options": [
            "Tidak ada peran",
            "Membimbing dan memberikan perspektif baru",
            "Menggantikan usaha pribadi",
            "Membatasi eksplorasi",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa penting mengenali kekuatan diri?",
          "options": [
            "Untuk menyombongkan diri",
            "Agar bisa fokus mengembangkan yang terbaik",
            "Tidak penting sama sekali",
            "Hanya untuk resume",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana sikap terhadap kelemahan diri?",
          "options": [
            "Menyembunyikan dan mengabaikan",
            "Terima dan kembangkan menjadi kekuatan",
            "Malu dan menyerah",
            "Menyalahkan orang lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang membedakan potensi dan prestasi?",
          "options": [
            "Tidak ada perbedaan",
            "Potensi adalah kemampuan, prestasi adalah hasil",
            "Prestasi lebih penting",
            "Potensi tidak bisa diukur",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 1: Mencari Hal Yang Kamu Suka - Quiz 5 (Karir Impian)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka_quiz5") {
      return [
        {
          "question": "Bagaimana memilih karir yang tepat?",
          "options": [
            "Ikuti yang paling populer",
            "Sesuaikan dengan minat, bakat, dan nilai pribadi",
            "Pilih yang gajinya paling tinggi",
            "Ikuti keinginan orang tua",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu career path?",
          "options": [
            "Jalan untuk berjalan-jalan",
            "Jalur perkembangan karir dari awal hingga tujuan",
            "Pekerjaan sampingan",
            "Tidak ada artinya",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa riset karir itu penting?",
          "options": [
            "Tidak penting",
            "Memahami realita pekerjaan dan peluang",
            "Hanya untuk formalitas",
            "Membuang waktu",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Apa yang harus dilakukan jika karir impian tidak realistis?",
          "options": [
            "Langsung menyerah",
            "Cari alternatif yang mendekati atau buat rencana bertahap",
            "Paksakan tetap",
            "Abaikan impian",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana peran networking dalam karir?",
          "options": [
            "Tidak berperan",
            "Membuka peluang dan koneksi profesional",
            "Hanya untuk pamer",
            "Tidak penting di era digital",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang dimaksud dengan work-life integration?",
          "options": [
            "Bekerja 24 jam",
            "Menyeimbangkan pekerjaan dengan kehidupan pribadi",
            "Tidak ada batasan kerja",
            "Mengabaikan kehidupan pribadi",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 1: Mencari Hal Yang Kamu Suka - Quiz 6 (Pengembangan Minat)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka_quiz6") {
      return [
        {
          "question": "Bagaimana cara mengembangkan minat menjadi keahlian?",
          "options": [
            "Hanya bermimpi",
            "Latihan konsisten dan pembelajaran berkelanjutan",
            "Menunggu bakat muncul sendiri",
            "Tidak perlu usaha",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu deliberate practice?",
          "options": [
            "Latihan asal-asalan",
            "Latihan terfokus dengan tujuan spesifik",
            "Latihan tanpa target",
            "Tidak pernah latihan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa feedback penting dalam pengembangan minat?",
          "options": [
            "Tidak penting",
            "Membantu identifikasi area yang perlu diperbaiki",
            "Hanya untuk kritik",
            "Membuat down",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Berapa lama biasanya menguasai suatu keahlian?",
          "options": [
            "Seminggu",
            "Berbeda untuk setiap orang, butuh waktu dan konsistensi",
            "Sebulan sudah ahli",
            "Tidak perlu waktu lama",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran komunitas dalam mengembangkan minat?",
          "options": [
            "Tidak ada peran",
            "Memberikan support dan sharing knowledge",
            "Hanya untuk bergaul",
            "Membuat distraksi",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana mengatasi plateau dalam pengembangan skill?",
          "options": [
            "Menyerah",
            "Cari tantangan baru dan ubah metode latihan",
            "Berhenti berlatih",
            "Tetap dengan cara lama",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 2: Mengatur Waktu - Quiz 4 (Disiplin Waktu)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengatur_waktu_quiz4") {
      return [
        {
          "question": "Apa yang dimaksud dengan disiplin waktu?",
          "options": [
            "Bekerja sepanjang hari",
            "Konsisten mengikuti jadwal yang telah dibuat",
            "Tidak pernah istirahat",
            "Kerja tanpa rencana",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana membangun kebiasaan disiplin?",
          "options": [
            "Langsung sempurna",
            "Mulai dari hal kecil dan konsisten",
            "Tunggu motivasi datang",
            "Tidak perlu kebiasaan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa dampak tidak disiplin terhadap produktivitas?",
          "options": [
            "Tidak ada dampak",
            "Menurunkan produktivitas dan hasil kerja",
            "Meningkatkan kreativitas",
            "Membuat lebih bahagia",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Berapa lama membentuk kebiasaan baru?",
          "options": [
            "1 hari",
            "Rata-rata 21-66 hari tergantung kompleksitas",
            "1 tahun",
            "Tidak bisa dibentuk",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu accountability partner?",
          "options": [
            "Musuh",
            "Teman yang saling mendukung mencapai tujuan",
            "Atasan yang galak",
            "Tidak ada gunanya",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana mengatasi godaan menunda?",
          "options": [
            "Ikuti saja",
            "Ingat tujuan dan mulai dari langkah kecil",
            "Tunggu besok",
            "Abaikan deadline",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 2: Mengatur Waktu - Quiz 5 (Efisiensi Kerja)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengatur_waktu_quiz5") {
      return [
        {
          "question": "Apa yang dimaksud dengan work smart not hard?",
          "options": [
            "Malas bekerja",
            "Bekerja dengan strategi efektif",
            "Kerja sebentar saja",
            "Tidak perlu usaha",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara mengurangi time wasters?",
          "options": [
            "Diabaikan saja",
            "Identifikasi dan eliminasi aktivitas tidak produktif",
            "Tambah aktivitas lain",
            "Tidak perlu dikurangi",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu automation dalam efisiensi kerja?",
          "options": [
            "Robot mengerjakan semua",
            "Menggunakan teknologi untuk tugas berulang",
            "Tidak ada gunanya",
            "Hanya untuk pabrik",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa delegasi penting untuk efisiensi?",
          "options": [
            "Agar bisa malas",
            "Fokus pada tugas prioritas tinggi",
            "Lepas tanggung jawab",
            "Tidak penting",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu Pareto Principle (80/20)?",
          "options": [
            "80% waktu untuk istirahat",
            "80% hasil dari 20% usaha yang tepat",
            "Bekerja 80 jam seminggu",
            "20% hasil dari 80% usaha",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana mengukur efisiensi kerja?",
          "options": [
            "Tidak bisa diukur",
            "Bandingkan output dengan input (waktu/tenaga)",
            "Lihat jam kerja saja",
            "Tanya bos",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 2: Mengatur Waktu - Quiz 6 (Work-Life Balance)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengatur_waktu_quiz6") {
      return [
        {
          "question": "Apa yang dimaksud dengan work-life balance?",
          "options": [
            "Tidak pernah bekerja",
            "Keseimbangan antara pekerjaan dan kehidupan pribadi",
            "Kerja 24 jam",
            "Hanya fokus pada karir",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa work-life balance penting?",
          "options": [
            "Tidak penting",
            "Mencegah burnout dan menjaga kesehatan",
            "Untuk malas kerja",
            "Menurunkan produktivitas",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana menetapkan boundaries dalam pekerjaan?",
          "options": [
            "Tidak perlu boundaries",
            "Tentukan jam kerja dan waktu pribadi yang jelas",
            "Selalu available 24/7",
            "Abaikan semua pekerjaan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa dampak tidak ada work-life balance?",
          "options": [
            "Tidak ada dampak",
            "Stres, burnout, dan masalah kesehatan",
            "Lebih sukses",
            "Lebih bahagia",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara maintain work-life balance saat WFH?",
          "options": [
            "Kerja di kasur sepanjang hari",
            "Buat jadwal dan ruang kerja terpisah",
            "Tidak ada bedanya",
            "Kerja sambil main HP",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran self-care dalam work-life balance?",
          "options": [
            "Tidak berperan",
            "Menjaga kesehatan fisik dan mental",
            "Hanya untuk orang kaya",
            "Membuang waktu",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 3: Berpikir Positif - Quiz 4 (Optimisme)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "berpikir_positif_quiz4") {
      return [
        {
          "question": "Apa yang dimaksud dengan optimisme?",
          "options": [
            "Percaya hal baik akan terjadi",
            "Mengabaikan kenyataan",
            "Tidak pernah sedih",
            "Selalu tersenyum palsu",
          ],
          "correctAnswer": 0,
        },
        {
          "question": "Apa perbedaan optimisme dan positive thinking?",
          "options": [
            "Tidak ada perbedaan",
            "Optimisme lebih realistis dan action-oriented",
            "Optimisme lebih naif",
            "Positive thinking lebih buruk",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana orang optimis menghadapi kegagalan?",
          "options": [
            "Langsung menyerah",
            "Melihat sebagai temporary dan belajar darinya",
            "Menyalahkan orang lain",
            "Menghindari tantangan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa manfaat optimisme untuk kesehatan?",
          "options": [
            "Tidak ada manfaat",
            "Menurunkan stres dan meningkatkan imun",
            "Membuat sakit",
            "Tidak ada hubungannya",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apakah optimisme bisa dipelajari?",
          "options": [
            "Tidak, harus bawaan lahir",
            "Ya, melalui latihan dan mindset shift",
            "Hanya untuk orang tertentu",
            "Tidak mungkin diubah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu realistic optimism?",
          "options": [
            "Optimisme tanpa dasar",
            "Optimisme yang mempertimbangkan realita",
            "Pesimisme terselubung",
            "Tidak ada bedanya",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 3: Berpikir Positif - Quiz 5 (Motivasi Diri)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "berpikir_positif_quiz5") {
      return [
        {
          "question": "Apa yang dimaksud dengan intrinsic motivation?",
          "options": [
            "Motivasi dari hadiah",
            "Motivasi dari dalam diri sendiri",
            "Motivasi dari tekanan",
            "Tidak ada motivasi",
          ],
          "correctAnswer": 1,
        },
        {
          "question":
              "Mana yang lebih sustainable, intrinsic atau extrinsic motivation?",
          "options": [
            "Extrinsic",
            "Intrinsic",
            "Sama saja",
            "Tidak ada yang sustainable",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara menemukan motivasi intrinsik?",
          "options": [
            "Cari hadiah besar",
            "Kaitkan dengan nilai dan tujuan pribadi",
            "Tunggu motivasi datang",
            "Tidak perlu dicari",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang harus dilakukan saat kehilangan motivasi?",
          "options": [
            "Menyerah",
            "Ingat kembali 'why' dan istirahat sejenak",
            "Paksakan terus",
            "Ganti tujuan",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran visualization dalam motivasi?",
          "options": [
            "Tidak berperan",
            "Membantu melihat tujuan lebih jelas",
            "Hanya mimpi",
            "Membuang waktu",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana self-discipline berkaitan dengan motivasi?",
          "options": [
            "Tidak ada hubungan",
            "Discipline mengambil alih saat motivasi menurun",
            "Discipline membunuh motivasi",
            "Hanya butuh salah satu",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // 🎯 CARD 3: Berpikir Positif - Quiz 6 (Kesejahteraan Mental)
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "berpikir_positif_quiz6") {
      return [
        {
          "question": "Apa yang dimaksud dengan mental wellbeing?",
          "options": [
            "Tidak pernah sedih",
            "Kondisi kesehatan mental yang baik secara keseluruhan",
            "Selalu bahagia",
            "Tidak ada masalah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa tanda kesehatan mental yang baik?",
          "options": [
            "Tidak pernah stres",
            "Bisa mengelola emosi dan stres dengan baik",
            "Selalu ceria",
            "Tidak punya masalah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa penting menjaga kesehatan mental?",
          "options": [
            "Tidak penting",
            "Mempengaruhi kualitas hidup keseluruhan",
            "Hanya untuk orang tertentu",
            "Tidak ada manfaatnya",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang dimaksud dengan mindfulness?",
          "options": [
            "Memikirkan masa depan",
            "Kesadaran penuh pada momen present",
            "Melamun",
            "Tidak berpikir",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Kapan harus mencari bantuan profesional?",
          "options": [
            "Tidak pernah perlu",
            "Saat masalah mental mengganggu fungsi sehari-hari",
            "Hanya untuk orang gila",
            "Tunggu sampai parah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran social connection untuk mental wellbeing?",
          "options": [
            "Tidak berperan",
            "Memberikan dukungan emosional dan sense of belonging",
            "Membuat stres",
            "Tidak penting",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    // ❌ No quiz available for this module/section
    return [];
  }

  Future<void> _submitXPToBackend() async {
    if (_isSubmittingXP) return;

    setState(() {
      _isSubmittingXP = true;
    });

    try {
      print('📤 Mengirim XP: ${widget.xpReward} untuk ${widget.subSection}');

      final response = await _apiClient.patch(
        ApiEndpoints.stats,
        body: {'xp': widget.xpReward},
        requiresAuth: true,
      );

      print('📥 Response: $response');

      if (response['success'] == true) {
        final updatedXP = response['stats']?['xp'] ?? response['data']?['xp'];
        print(
          '✅ XP berhasil ditambahkan: ${widget.xpReward} (Total: $updatedXP)',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('XP +${widget.xpReward} berhasil ditambahkan! 🎉'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Gagal menambah XP: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah XP: ${e.toString()}'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingXP = false;
        });
      }
    }
  }

  void _submitQuiz() async {
    final questions = _getQuestions();
    final isCorrect =
        selectedAnswer == questions[currentQuestionIndex]["correctAnswer"];

    if (isCorrect) {
      // Jawaban Benar
      correctAnswers++;
      await _showCorrectAnswerDialog();
    } else {
      // Jawaban Salah - Tampilkan alert dan user harus jawab ulang
      await _showWrongAnswerDialog();
      return; // Tidak lanjut ke soal berikutnya
    }

    // Lanjut ke soal berikutnya atau tampilkan hasil
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        showResult = true;
      });
      // ✅ Kirim XP ke backend saat quiz selesai
      await _submitXPToBackend();

      // ✅ Update streak via API setelah quiz selesai
      print('🎮 Quiz completed, updating streak...');
      final streakUpdated = await _streakService.updateStreak();

      if (streakUpdated && mounted) {
        // ✅ Refresh ProfileBloc untuk update UI (fire icon & streak count)
        context.read<ProfileBloc>().add(RefreshProfile());
        print('🔥 Streak updated and profile refreshed!');
      }
    }
  }

  Future<void> _showCorrectAnswerDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/icons/check.png"),
              const SizedBox(height: 16),
              Text(
                "Jawaban Benar!",
                style: primaryTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Luar biasa! Kamu berhasil menjawab dengan benar.",
                textAlign: TextAlign.center,
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              CustomFilledButton(
                title: "OK",
                variant: ButtonColorVariant.blue,
                onPressed: () => Navigator.of(context).pop(),
                height: 50,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showWrongAnswerDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/icons/uncheck.png"),
              const SizedBox(height: 16),
              Text(
                "Jawaban Salah!",
                style: primaryTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Coba lagi! Kamu harus menjawab dengan benar untuk melanjutkan ke soal berikutnya.",
                textAlign: TextAlign.center,
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),
              CustomFilledButton(
                title: "Coba Lagi",
                variant: ButtonColorVariant.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reset pilihan jawaban agar user bisa pilih ulang
                  setState(() {
                    selectedAnswer = null;
                  });
                },
                height: 50,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = _getQuestions();
    final totalQuestions = questions.length;

    // ❌ No questions available - show error page
    if (totalQuestions == 0) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(0.0),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Quiz Tidak Tersedia',
                          style: primaryTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Quiz untuk modul ini belum tersedia. Silakan coba modul lain.',
                          style: secondaryTextStyle.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        CustomFilledButton(
                          title: "Kembali",
                          variant: ButtonColorVariant.blue,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (showResult) {
      return _buildResultPage(totalQuestions);
    }

    final currentQuestion = questions[currentQuestionIndex];
    double progress = (currentQuestionIndex + 1) / totalQuestions;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(progress),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Soal ${currentQuestionIndex + 1} dari $totalQuestions",
                      style: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQuestion["question"],
                      style: primaryTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(
                      currentQuestion["options"].length,
                      (index) => _answerOption(
                        index,
                        currentQuestion["options"][index],
                      ),
                    ),
                    const Spacer(),
                    CustomFilledButton(
                      title: "Kirim Jawaban",
                      variant: selectedAnswer != null
                          ? ButtonColorVariant.blue
                          : ButtonColorVariant.secondary,
                      onPressed: selectedAnswer != null ? _submitQuiz : null,
                      withShadow: selectedAnswer != null,
                      height: 55,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
                minHeight: 12,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.local_fire_department,
              color: progress == 1.0 ? Colors.orange : Colors.grey,
            ),
            onPressed: null,
          ),
        ],
      ),
    );
  }

  Widget _answerOption(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedAnswer = index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedAnswer == index
              ? const Color(0xFF2B8DD8).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedAnswer == index
                ? const Color(0xFF2B8DD8)
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedAnswer == index
                      ? const Color(0xFF2B8DD8)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: selectedAnswer == index
                    ? const Color(0xFF2B8DD8)
                    : Colors.white,
              ),
              child: selectedAnswer == index
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: primaryTextStyle.copyWith(
                  fontSize: 15,
                  fontWeight: selectedAnswer == index ? semiBold : regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPage(int totalQuestions) {
    final xpEarned = widget.xpReward; // ✅ Use dynamic XP
    String personalityType = "Investigatif";
    String personalityDesc =
        "Artinya, kamu seorang pemikir alami yang suka menganalisis dan memecahkan masalah. Cocok menjadi Ahli Matematika, Programmer, atau Apoteker.";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(1.0),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B8DD8).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  xpEarned == 80
                      ? "Runtunan telah terbuka!"
                      : "🔄 Replay Selesai!",
                  style: bluePrimaryTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846602/character14_tdcjvv.png',
                      width: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Tipe kepribadianmu adalah $personalityType.",
                      textAlign: TextAlign.center,
                      style: primaryTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      personalityDesc,
                      textAlign: TextAlign.center,
                      style: primaryTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: regular,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        _isSubmittingXP
                            ? const CircularProgressIndicator()
                            : Image.asset(
                                'assets/images/Frame 172.png',
                                width: 42,
                                height: 42,
                              ),
                        const SizedBox(height: 6),
                        Text(
                          "Total XP",
                          style: secondaryTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$xpEarned",
                          style: primaryTextStyle.copyWith(
                            fontSize: 22,
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    CustomFilledButton(
                      title: "Selanjutnya",
                      variant: ButtonColorVariant.blue,
                      onPressed: _isSubmittingXP
                          ? null
                          : () => Navigator.pop(context),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }
}
