import 'package:flutter/material.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResumePage extends StatefulWidget {
  final String moduleId;
  final String sectionId;
  final String subSection;
  final int xpReward;

  const ResumePage({
    super.key,
    required this.moduleId,
    required this.sectionId,
    required this.subSection,
    this.xpReward = 80,
  });

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final TextEditingController _resumeController = TextEditingController();
  bool hasText = false;
  final ApiClient _apiClient = ApiClient();

  Map<String, dynamic> _getResumeData() {
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "mencari_hal_yang_kamu_suka") {
      return {
        "title": "Buat Resume Video",
        "subtitle": "Mengenal Minat Dan Bakat",
        "placeholder":
            "Tuliskan pemahamanmu tentang video yang baru saja kamu tonton...\n\nContoh:\n- Apa yang kamu pelajari?\n- Bagaimana cara mengidentifikasi minat?\n- Apa hubungan minat dengan karir?",
      };
    }

    if (widget.moduleId == "modul2" &&
        widget.sectionId == "bagian1" &&
        widget.subSection == "persiapan_karir") {
      return {
        "title": "Buat Resume Video",
        "subtitle": "Persiapan Karir",
        "placeholder":
            "Tuliskan pemahamanmu tentang video yang baru saja kamu tonton...\n\nContoh:\n- Apa yang kamu pelajari?\n- Langkah apa saja untuk persiapan karir?\n- Bagaimana strategi memasuki dunia kerja?",
      };
    }

    return {
      "title": "Buat Resume Video",
      "subtitle": "Materi Pembelajaran",
      "placeholder":
          "Tuliskan pemahamanmu tentang video yang baru saja kamu tonton...",
    };
  }

  @override
  void initState() {
    super.initState();
    _resumeController.addListener(() {
      setState(() {
        hasText = _resumeController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _resumeController.dispose();
    _apiClient.dispose();
    super.dispose();
  }

  Future<void> _submitXPToBackend() async {
    try {
      print('📤 Mengirim XP dari Resume: ${widget.xpReward}');

      final response = await _apiClient.patch(
        ApiEndpoints.stats,
        body: {'xp': widget.xpReward}, // ✅ Use dynamic XP
        requiresAuth: true,
      );

      print('📥 Response: $response');

      if (response['success'] == true) {
        final updatedXP = response['stats']?['xp'] ?? response['data']?['xp'];
        print(
          '✅ XP berhasil ditambahkan: ${widget.xpReward} (Total: $updatedXP)',
        );
      }
    } catch (e) {
      print('❌ Gagal menambah XP dari Resume: $e');
    }
  }

  void _submitResume() async {
    if (hasText) {
      await _submitXPToBackend();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResumeResultPage(xpReward: widget.xpReward),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumeData = _getResumeData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resumeData["title"],
                      style: primaryTextStyle.copyWith(
                        fontSize: 24,
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resumeData["subtitle"],
                      style: secondaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _resumeController,
                        maxLines: 15,
                        decoration: InputDecoration(
                          hintText: resumeData["placeholder"],
                          hintStyle: secondaryTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Tips: Tulis minimal 3 poin penting yang kamu pelajari",
                            style: secondaryTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomFilledButton(
                title: "Lanjut ke Soal +${widget.xpReward} XP", // ✅ Dynamic XP
                variant: hasText
                    ? ButtonColorVariant.blue
                    : ButtonColorVariant.secondary,
                onPressed: hasText ? _submitResume : null,
                withShadow: hasText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.5,
                backgroundColor: const Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
                minHeight: 12,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.local_fire_department, color: Colors.grey),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

// ✅ New Result Page after Resume Submission
class ResumeResultPage extends StatelessWidget {
  final int xpReward;

  const ResumeResultPage({super.key, required this.xpReward});

  @override
  Widget build(BuildContext context) {
    String personalityType = "Investigatif";
    String personalityDesc =
        "Artinya, kamu seorang pemikir alami yang suka menganalisis dan memecahkan masalah. Cocok menjadi Ahli Matematika, Programmer, atau Apoteker.";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(context),
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
                  xpReward == 80
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
                        Icon(
                          Icons.add_circle,
                          color: xpReward == 80
                              ? const Color(0xFF2B8DD8)
                              : Colors.orange,
                          size: 32,
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
                          "$xpReward",
                          style: primaryTextStyle.copyWith(
                            fontSize: 22,
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomFilledButton(
                      title: "Selanjutnya",
                      variant: ButtonColorVariant.blue,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
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
                value: 1.0,
                backgroundColor: const Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
                minHeight: 12,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.local_fire_department, color: Colors.orange),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
