import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/form_cv.dart';

class CVEducation extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CVEducation({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<CVEducation> createState() => _CVEducationState();
}

class _CVEducationState extends State<CVEducation> {
  List<Map<String, TextEditingController>> educations = [];
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    addEducation();
  }

  void addEducation() {
    educations.add({
      "school": TextEditingController(),
      "location": TextEditingController(),
      "major": TextEditingController(),
      "start": TextEditingController(),
      "end": TextEditingController(),
      "description": TextEditingController(),
    });
    expanded.add(true);
    setState(() {});
  }

  void removeEducation(int index) {
    for (var c in educations[index].values) {
      c.dispose();
    }
    educations.removeAt(index);
    expanded.removeAt(index);
    if (mounted) setState(() {});
  }

  void toggleExpand(int index) {
    if (index < 0 || index >= expanded.length) return;
    setState(() => expanded[index] = !expanded[index]);
  }

  @override
  void dispose() {
    for (var item in educations) {
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
          padding: const EdgeInsets.only(left: 24.0, top: 0, right: 24.0, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pendidikan',
                  style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold)),
              const SizedBox(height: 6),
              Text(
                'Tambahkan detail pendidikan Anda - meskipun belum lulus.',
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(
                        educations.length,
                        (i) => buildEducationCard(educations[i], i),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: addEducation,
                          child: Text(
                            "+ Tambah pendidikan",
                            style: primaryTextStyle.copyWith(
                                color: bluePrimaryColor, fontWeight: semiBold),
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
                onPressed: widget.onNext,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEducationCard(Map<String, TextEditingController> data, int index) {
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
                  "Pendidikan, Sekolah",
                  style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
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
                onPressed: () => removeEducation(index),
                icon: Icon(Icons.delete_outline, color: Colors.grey.shade400, size: 18),
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
                      buildInputCV("Nama Sekolah", data["school"]!,
                          hint: "SMA / Universitas"),
                      buildInputCV("Lokasi", data["location"]!, hint: "Yogyakarta"),
                      buildInputCV("Penjurusan", data["major"]!,
                          hint: "IPS / Teknik Informatika"),
                      Row(
                        children: [
                          Expanded(
                            child: buildInputCV("Tanggal mulai", data["start"]!,
                                hint: "07/2018", keyboard: TextInputType.datetime),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildInputCV("Tanggal selesai", data["end"]!,
                                hint: "05/2021", keyboard: TextInputType.datetime),
                          ),
                        ],
                      ),
                      buildTextAreaCV("Deskripsi", data["description"]!,
                          hint: "Organisasi, prestasi, aktivitas, dll."),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey(false)),
          ),
        ],
      ),
    );
  }
}
