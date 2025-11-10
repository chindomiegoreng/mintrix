import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/models/cv_model.dart';
import 'package:mintrix/features/game/bloc/build_cv_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class CVSkills extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CVSkills({super.key, required this.onNext, required this.onBack});

  @override
  State<CVSkills> createState() => _CVSkillsState();
}

class _CVSkillsState extends State<CVSkills> {
  List<TextEditingController> skillControllers = [];
  List<int> levels = [];
  bool showLevels = true;

  @override
  void initState() {
    super.initState();
    addSkill();
  }

  void addSkill() {
    skillControllers.add(TextEditingController());
    levels.add(1);
    setState(() {});
  }

  void removeSkill(int index) {
    skillControllers[index].dispose();
    skillControllers.removeAt(index);
    levels.removeAt(index);
    setState(() {});
  }

  @override
  void dispose() {
    for (var c in skillControllers) {
      c.dispose();
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
                'Keterampilan',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tambahkan keterampilan profesional Anda yang paling relevan.',
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 14),

              /// TOGGLE
              Row(
                children: [
                  Transform.scale(
                    scale: 0.78,
                    child: Switch(
                      value: showLevels,
                      activeColor: bluePrimaryColor,
                      onChanged: (v) => setState(() => showLevels = v),
                    ),
                  ),
                  Text(
                    "Tampilkan tingkat keahlian",
                    style: primaryTextStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(skillControllers.length, (i) {
                        return buildSkillCard(i);
                      }),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: addSkill,
                          child: Text(
                            "+ Tambah Keterampilan",
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

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomFilledButton(
            title: "Selanjutnya",
            variant: ButtonColorVariant.blue,
            onPressed: () {
              // Validate skills data
              bool hasValidSkill = false;
              for (int i = 0; i < skillControllers.length; i++) {
                if (skillControllers[i].text.trim().isNotEmpty) {
                  hasValidSkill = true;
                  break;
                }
              }

              if (!hasValidSkill) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Minimal satu keterampilan diperlukan'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Save skills data to bloc before navigating
              final skillsData = List.generate(skillControllers.length, (
                index,
              ) {
                return CVKeterampilan(
                  namaKeterampilan: skillControllers[index].text.trim(),
                  level: index < levels.length ? levels[index] : 1,
                );
              }).where((skill) => skill.namaKeterampilan.isNotEmpty).toList();

              context.read<BuildCVBloc>().add(UpdateSkillsData(skillsData));
              widget.onNext();
            },
          ),
        ),
      ),
    );
  }

  Widget buildSkillCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: thirdColor, width: 1.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Keterampilan",
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: skillControllers[index],
            decoration: InputDecoration(
              hintText: "Contoh: Figma",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          if (showLevels) ...[
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Level — ",
                    style: primaryTextStyle.copyWith(
                      fontSize: 13,
                      fontWeight: semiBold,
                    ),
                  ),
                  TextSpan(
                    text: getLevelName(levels[index]),
                    style: secondaryTextStyle.copyWith(
                      fontSize: 13,
                      fontWeight: regular,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            buildLevelSlider(index),
          ],
        ],
      ),
    );
  }

  Widget buildLevelSlider(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = 50.0; // dibuat lebih gemuk

        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  double relative = (details.localPosition.dx / width).clamp(
                    0,
                    1,
                  );
                  setState(() {
                    levels[index] = (relative * 5).clamp(1, 5).round();
                  });
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7FD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: (levels[index] / 5) * width,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: bluePrimaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    Positioned.fill(
                      child: Row(
                        children: List.generate(5, (i) {
                          if (i == 0) return const SizedBox();
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.white.withOpacity(0.45),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 3),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.delete_outline,
                color: bluePrimaryColor,
                size: 24,
              ),
              onPressed: () => removeSkill(index),
            ),
          ],
        );
      },
    );
  }

  String getLevelName(int lvl) {
    switch (lvl) {
      case 1:
        return "Pemula";
      case 2:
        return "Dasar";
      case 3:
        return "Menengah";
      case 4:
        return "Mahir";
      case 5:
        return "Ahli";
      default:
        return "";
    }
  }
}
