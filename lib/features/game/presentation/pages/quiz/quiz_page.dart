import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/shared/theme.dart';

class QuizPage extends StatefulWidget {
  final String moduleId;
  final String sectionId;
  final String subSection;

  const QuizPage({
    super.key,
    required this.moduleId,
    required this.sectionId,
    required this.subSection,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int correctAnswers = 0;
  bool showResult = false;

  List<Map<String, dynamic>> _getQuestions() {
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka") {
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

    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengatur_waktu") {
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

    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "berpikir_positif") {
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

    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "komunikasi_efektif") {
      return [
        {
          "question": "Apa yang dimaksud dengan komunikasi efektif?",
          "options": [
            "Berbicara sebanyak mungkin",
            "Menyampaikan pesan dengan jelas dan dipahami",
            "Menghindari berbicara dengan orang lain",
            "Selalu memaksakan pendapat",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa komponen penting dalam mendengarkan aktif?",
          "options": [
            "Memotong pembicaraan orang lain",
            "Fokus pada handphone saat berbicara",
            "Memberikan perhatian penuh dan memahami",
            "Memikirkan jawaban sambil orang bicara",
          ],
          "correctAnswer": 2,
        },
        {
          "question": "Bagaimana body language mempengaruhi komunikasi?",
          "options": [
            "Tidak berpengaruh sama sekali",
            "Dapat memperkuat atau melemahkan pesan",
            "Hanya penting dalam presentasi",
            "Tidak penting dalam era digital",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang dimaksud dengan komunikasi asertif?",
          "options": [
            "Berbicara dengan kasar",
            "Mengekspresikan pendapat dengan sopan dan tegas",
            "Selalu mengalah pada orang lain",
            "Menghindari konflik dengan diam",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa hambatan umum dalam komunikasi?",
          "options": [
            "Terlalu banyak mendengarkan",
            "Prasangka dan asumsi negatif",
            "Berbicara dengan sopan",
            "Memahami perspektif orang lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara memberikan kritik yang membangun?",
          "options": [
            "Fokus pada kesalahan orangnya",
            "Menyampaikan di depan banyak orang",
            "Fokus pada perilaku, bukan pribadi",
            "Menggunakan kata-kata kasar",
          ],
          "correctAnswer": 2,
        },
      ];
    }

    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "kerja_sama_tim") {
      return [
        {
          "question": "Apa manfaat utama bekerja dalam tim?",
          "options": [
            "Bisa mengandalkan orang lain sepenuhnya",
            "Menggabungkan keahlian untuk hasil lebih baik",
            "Menghindari tanggung jawab pribadi",
            "Membuat pekerjaan lebih lambat",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa karakteristik anggota tim yang baik?",
          "options": [
            "Selalu mendominasi diskusi",
            "Mendengarkan dan menghargai pendapat orang lain",
            "Mengerjakan semua tugas sendiri",
            "Menyalahkan orang lain saat ada masalah",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana mengatasi konflik dalam tim?",
          "options": [
            "Menghindari konflik dan berpura-pura setuju",
            "Komunikasi terbuka dan mencari solusi bersama",
            "Memaksakan pendapat pribadi",
            "Keluar dari tim",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa peran pemimpin dalam tim?",
          "options": [
            "Membuat semua keputusan sendiri",
            "Mengarahkan dan memfasilitasi kolaborasi",
            "Menyalahkan anggota yang gagal",
            "Tidak ikut bekerja sama",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang dimaksud dengan sinergi dalam tim?",
          "options": [
            "Bekerja sendiri-sendiri",
            "Hasil bersama lebih besar dari jumlah individu",
            "Mengikuti pemimpin tanpa bertanya",
            "Menghindari tanggung jawab",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana membangun kepercayaan dalam tim?",
          "options": [
            "Menyembunyikan informasi",
            "Transparansi dan konsisten dalam tindakan",
            "Bersaing dengan anggota lain",
            "Tidak peduli dengan kontribusi orang lain",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mengelola_emosi") {
      return [
        {
          "question": "Apa yang dimaksud dengan kecerdasan emosional?",
          "options": [
            "Tidak pernah merasakan emosi",
            "Kemampuan mengenali dan mengelola emosi",
            "Selalu terlihat bahagia",
            "Mengabaikan perasaan orang lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara mengenali emosi diri sendiri?",
          "options": [
            "Mengabaikan perasaan",
            "Refleksi dan menyadari reaksi tubuh",
            "Menyalahkan orang lain",
            "Menekan semua emosi",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang sebaiknya dilakukan saat merasa marah?",
          "options": [
            "Melampiaskan pada orang lain",
            "Tarik napas dalam dan tenangkan diri",
            "Membentak siapa saja",
            "Membanting barang",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa manfaat mengelola emosi dengan baik?",
          "options": [
            "Tidak ada manfaatnya",
            "Hubungan lebih harmonis dan produktif",
            "Menjadi orang yang kaku",
            "Kehilangan kepribadian",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa itu empati?",
          "options": [
            "Mengabaikan perasaan orang lain",
            "Memahami dan merasakan perasaan orang lain",
            "Menyalahkan orang atas emosi mereka",
            "Tidak peduli dengan orang lain",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Bagaimana cara mengatasi stres dengan sehat?",
          "options": [
            "Mengonsumsi hal yang tidak sehat",
            "Olahraga, meditasi, atau berbicara dengan teman",
            "Menghindari semua orang",
            "Tidur sepanjang hari",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "menetapkan_tujuan") {
      return [
        {
          "question": "Apa pentingnya menetapkan tujuan dalam hidup?",
          "options": [
            "Tidak ada pentingnya",
            "Memberikan arah dan motivasi",
            "Membuat hidup lebih rumit",
            "Hanya untuk orang ambisius",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa kepanjangan dari SMART dalam goal setting?",
          "options": [
            "Simple, Minimal, Achievable, Realistic, Timely",
            "Specific, Measurable, Achievable, Relevant, Time-bound",
            "Strong, Meaningful, Active, Ready, True",
            "Special, Modern, Attractive, Real, Tactical",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa perbedaan tujuan jangka pendek dan jangka panjang?",
          "options": [
            "Tidak ada perbedaan",
            "Waktu pencapaian dan cakupannya",
            "Tingkat kesulitannya saja",
            "Tujuan pendek lebih penting",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang harus dilakukan jika tujuan tidak tercapai?",
          "options": [
            "Menyerah sepenuhnya",
            "Evaluasi, pelajari, dan buat strategi baru",
            "Menyalahkan keadaan",
            "Menghindari tujuan baru",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Mengapa penting menulis tujuan?",
          "options": [
            "Tidak penting, cukup diingat",
            "Membuat komitmen lebih kuat dan terukur",
            "Hanya untuk formalitas",
            "Agar terlihat sibuk",
          ],
          "correctAnswer": 1,
        },
        {
          "question": "Apa yang dimaksud dengan action plan?",
          "options": [
            "Daftar impian tanpa rencana",
            "Langkah konkret untuk mencapai tujuan",
            "Menunda tujuan",
            "Rencana tanpa tindakan",
          ],
          "correctAnswer": 1,
        },
      ];
    }

    return [
      {
        "question": "Pertanyaan default 1",
        "options": ["Opsi A", "Opsi B", "Opsi C", "Opsi D"],
        "correctAnswer": 0,
      },
    ];
  }

  void _submitAnswer() {
    final questions = _getQuestions();
    if (selectedAnswer == questions[currentQuestionIndex]["correctAnswer"]) {
      correctAnswers++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        showResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = _getQuestions();
    final totalQuestions = questions.length;

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
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQuestion["question"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
                      title: currentQuestionIndex < totalQuestions - 1
                          ? "Selanjutnya"
                          : "Selesai",
                      variant: selectedAnswer != null
                          ? ButtonColorVariant.blue
                          : ButtonColorVariant.secondary,
                      onPressed: selectedAnswer != null ? _submitAnswer : null,
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
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selectedAnswer == index
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPage(int totalQuestions) {
    final xpEarned = correctAnswers * 10;
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
                child: const Text(
                  "Runtunan telah terbuka!",
                  style: TextStyle(
                    color: Color(0xFF2B8DD8),
                    fontWeight: FontWeight.w600,
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
                    // Image.asset("assets/images/dino_gramed.png", height: 250),
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      personalityDesc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 32),

                    Column(
                      children: [
                        const Icon(
                          Icons.add_circle,
                          color: Color(0xFF2B8DD8),
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Total XP",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$xpEarned",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    CustomFilledButton(
                      title: "Selanjutnya",
                      variant: ButtonColorVariant.blue,
                      onPressed: () => Navigator.pop(context),
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
}
