import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/game/bloc/build_cv_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class CVSummary extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CVSummary({super.key, required this.onNext, required this.onBack});

  @override
  State<CVSummary> createState() => _CVSummaryState();
}

class _CVSummaryState extends State<CVSummary> {
  final TextEditingController summaryController = TextEditingController();
  int selectedIndex = -1;

  final List<String> templates = [
    "Profesional yang berorientasi pada detail dengan 3+ tahun pengalaman di [bidang]. Terampil dalam [keterampilan utama]. Ingin berkontribusi pada [jenis tim/perusahaan atau tujuan].",
    "Profesional yang fokus pada hasil dengan latar belakang 3+ tahun di [bidang]. Memiliki keterampilan dalam [keterampilan utama]. Siap mendukung pertumbuhan [tim/perusahaan].",
    "Profesional kreatif dengan pengalaman lebih dari 3 tahun di bidang [bidang]. Mahir menggunakan [tools/skill]. Berkomitmen untuk menciptakan solusi yang efektif dan inovatif.",
  ];

  void selectTemplate(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ringkasan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tulis perkenalan singkat yang menyoroti pengalaman, keterampilan utama, dan tujuan karier Anda.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: summaryController,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tulis ringkasan Anda di sini...',
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Struktur ringkasan yang disarankan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // ✅ Hanya bagian ini yang scroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(templates.length, (index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () => selectTemplate(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? bluePrimaryColor
                                : Colors.grey.shade300,
                            width: 1.6,
                          ),
                          color: isSelected
                              ? bluePrimaryColor.withOpacity(0.07)
                              : Colors.white,
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              color: isSelected
                                  ? bluePrimaryColor
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                templates[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomFilledButton(
            title: "Selanjutnya",
            variant: ButtonColorVariant.blue,
            onPressed: () {
              // Validate summary data
              String finalSummary = summaryController.text.trim();

              if (finalSummary.isEmpty &&
                  (selectedIndex < 0 || selectedIndex >= templates.length)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Silakan tulis ringkasan atau pilih template',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Save summary data to bloc before navigating
              if (finalSummary.isEmpty &&
                  selectedIndex >= 0 &&
                  selectedIndex < templates.length) {
                finalSummary = templates[selectedIndex];
              }

              context.read<BuildCVBloc>().add(UpdateSummaryData(finalSummary));
              widget.onNext();
            },
          ),
        ),
      ),
    );
  }
}
