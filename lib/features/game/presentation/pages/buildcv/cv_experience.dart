import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/models/cv_model.dart';
import 'package:mintrix/features/game/bloc/build_cv_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/form_cv.dart';

class CVExperience extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CVExperience({super.key, required this.onNext, required this.onBack});

  @override
  State<CVExperience> createState() => _CVExperienceState();
}

class _CVExperienceState extends State<CVExperience> {
  List<Map<String, TextEditingController>> experiences = [];
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    addExperience();
  }

  void addExperience() {
    experiences.add({
      "position": TextEditingController(),
      "company": TextEditingController(),
      "location": TextEditingController(),
      "start": TextEditingController(),
      "end": TextEditingController(),
      "description": TextEditingController(),
    });

    expanded.add(true);
    setState(() {});
  }

  void removeExperience(int index) {
    for (var c in experiences[index].values) {
      c.dispose();
    }
    experiences.removeAt(index);
    expanded.removeAt(index);
    if (mounted) setState(() {});
  }

  void toggleExpand(int index) {
    if (!mounted || index >= expanded.length) return;
    setState(() => expanded[index] = !expanded[index]);
  }

  @override
  void dispose() {
    for (var item in experiences) {
      for (var c in item.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            top: 0,
            right: 24.0,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengalaman',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tuliskan pengalaman kerjamu dimulai dari posisi terbaru',
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(
                        experiences.length,
                        (i) => buildExperienceCard(experiences[i], i),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: addExperience,
                          child: Text(
                            "+ Tambah pengalaman",
                            style: primaryTextStyle.copyWith(
                              color: bluePrimaryColor,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.transparent,
              child: CustomFilledButton(
                title: "Selanjutnya",
                variant: ButtonColorVariant.blue,
                onPressed: () {
                  // Validate experience data
                  for (int i = 0; i < experiences.length; i++) {
                    final exp = experiences[i];
                    if (exp["position"]?.text.trim().isEmpty == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Jabatan diperlukan untuk pengalaman ke-${i + 1}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (exp["company"]?.text.trim().isEmpty == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Perusahaan diperlukan untuk pengalaman ke-${i + 1}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (exp["location"]?.text.trim().isEmpty == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Lokasi diperlukan untuk pengalaman ke-${i + 1}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (exp["start"]?.text.trim().isEmpty == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tanggal mulai diperlukan untuk pengalaman ke-${i + 1}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  // Save experience data to bloc before navigating
                  final experienceData = experiences.map((exp) {
                    return CVPengalaman(
                      jabatan: exp["position"]?.text.trim() ?? '',
                      perusahaan: exp["company"]?.text.trim() ?? '',
                      lokasi: exp["location"]?.text.trim() ?? '',
                      tanggalMulai: exp["start"]?.text.trim() ?? '',
                      tanggalSelesai: exp["end"]?.text.trim().isEmpty == true
                          ? null
                          : exp["end"]?.text.trim(),
                      deskripsi: exp["description"]?.text.trim() ?? '',
                    );
                  }).toList();

                  context.read<BuildCVBloc>().add(
                    UpdateExperienceData(experienceData),
                  );
                  widget.onNext();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExperienceCard(
    Map<String, TextEditingController> data,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: thirdColor, width: 1.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Pengalaman, Jabatan",
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => toggleExpand(index),
                child: Icon(
                  expanded[index]
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 2),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 18,
                onPressed: () => removeExperience(index),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ),
            ],
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: expanded[index]
                ? Column(
                    key: ValueKey(true),
                    children: [
                      const SizedBox(height: 6),
                      buildInputCV(
                        "Jabatan",
                        data["position"]!,
                        hint: "UI/UX Designer",
                      ),
                      buildInputCV(
                        "Perusahaan",
                        data["company"]!,
                        hint: "PT Mencari Cinta Sejati",
                      ),
                      buildInputCV(
                        "Lokasi",
                        data["location"]!,
                        hint: "Sleman, Yogyakarta",
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildInputCV(
                              "Tanggal mulai",
                              data["start"]!,
                              hint: "07/2018",
                              keyboard: TextInputType.datetime,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildInputCV(
                              "Tanggal selesai",
                              data["end"]!,
                              hint: "05/2021",
                              keyboard: TextInputType.datetime,
                            ),
                          ),
                        ],
                      ),
                      buildTextAreaCV(
                        "Deskripsi",
                        data["description"]!,
                        hint: "Jelaskan tanggung jawab dan pencapaianmu",
                      ),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey(false)),
          ),
        ],
      ),
    );
  }
}
