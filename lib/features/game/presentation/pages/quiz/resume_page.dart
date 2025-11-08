import 'package:flutter/material.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/shared/theme.dart';
import 'quiz_page.dart';

class ResumePage extends StatefulWidget {
  final String moduleId;
  final String sectionId;
  final String subSection;

  const ResumePage({
    super.key,
    required this.moduleId,
    required this.sectionId,
    required this.subSection,
  });

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final TextEditingController _resumeController = TextEditingController();
  bool hasText = false;

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
      "placeholder": "Tuliskan pemahamanmu tentang video yang baru saja kamu tonton...",
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
    super.dispose();
  }

  void _submitResume() {
    if (hasText) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizPage(
            moduleId: widget.moduleId,
            sectionId: widget.sectionId,
            subSection: widget.subSection,
          ),
        ),
      );
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resumeData["subtitle"],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
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
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
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
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
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
                title: "Lanjut ke Soal +80 XP",
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
                valueColor: AlwaysStoppedAnimation<Color>(
                  bluePrimaryColor,
                ),
                minHeight: 12,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.local_fire_department,
              color: Colors.grey,
            ),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}