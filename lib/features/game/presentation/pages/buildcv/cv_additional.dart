import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/models/cv_model.dart';
import 'package:mintrix/features/game/bloc/build_cv_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class CVAdditional extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CVAdditional({super.key, required this.onNext, required this.onBack});

  @override
  State<CVAdditional> createState() => _CVAdditionalState();
}

class _CVAdditionalState extends State<CVAdditional> {
  List<TextEditingController> languageControllers = [];
  List<int> levels = [];

  bool showLanguage = true;
  bool showCert = false;
  bool showAward = false;
  bool showLink = false;
  bool showCustom = false;

  List<TextEditingController> certControllers = [];
  List<TextEditingController> awardControllers = [];
  List<TextEditingController> linkControllers = [];
  List<TextEditingController> customControllers = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    addLanguage();
  }

  void addLanguage() {
    languageControllers.add(TextEditingController());
    levels.add(1);
    setState(() {});
  }

  void clearLanguage() {
    for (var c in languageControllers) c.dispose();
    languageControllers.clear();
    levels.clear();
    setState(() {});
  }

  void removeLanguage(int index) {
    if (index >= languageControllers.length) return;
    languageControllers[index].dispose();
    languageControllers.removeAt(index);
    if (index < levels.length) levels.removeAt(index);
    setState(() {});
  }

  void addCert() {
    certControllers.add(TextEditingController());
    setState(() {});
  }

  void clearCert() {
    for (var c in certControllers) c.dispose();
    certControllers.clear();
    setState(() {});
  }

  void removeCert(int i) {
    certControllers[i].dispose();
    certControllers.removeAt(i);
    setState(() {});
  }

  void addAward() {
    awardControllers.add(TextEditingController());
    setState(() {});
  }

  void clearAward() {
    for (var c in awardControllers) c.dispose();
    awardControllers.clear();
    setState(() {});
  }

  void removeAward(int i) {
    awardControllers[i].dispose();
    awardControllers.removeAt(i);
    setState(() {});
  }

  void addLink() {
    linkControllers.add(TextEditingController());
    setState(() {});
  }

  void clearLink() {
    for (var c in linkControllers) c.dispose();
    linkControllers.clear();
    setState(() {});
  }

  void removeLink(int i) {
    linkControllers[i].dispose();
    linkControllers.removeAt(i);
    setState(() {});
  }

  void addCustom() {
    customControllers.add(TextEditingController());
    setState(() {});
  }

  void clearCustom() {
    for (var c in customControllers) c.dispose();
    customControllers.clear();
    setState(() {});
  }

  void removeCustom(int i) {
    customControllers[i].dispose();
    customControllers.removeAt(i);
    setState(() {});
  }

  @override
  void dispose() {
    for (var c in languageControllers) c.dispose();
    for (var c in certControllers) c.dispose();
    for (var c in awardControllers) c.dispose();
    for (var c in linkControllers) c.dispose();
    for (var c in customControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuildCVBloc, BuildCVState>(
      listener: (context, state) {
        debugPrint('🎧 CVAdditional BLoC Listener: ${state.runtimeType}');

        if (state is CVSubmitting) {
          debugPrint('⏳ CV is being submitted...');
          setState(() {
            _isSubmitting = true;
          });
        } else if (state is CVSubmitSuccess) {
          debugPrint('✅ CV Submit Success! Navigating to result...');
          debugPrint('📄 Resume ID: ${state.cvModel.id}');
          debugPrint('🔗 Resume Link: ${state.cvModel.resumeLink}');

          setState(() {
            _isSubmitting = false;
          });

          // Tunggu sebentar untuk memastikan state sudah tersimpan
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              widget.onNext();
            }
          });
        } else if (state is CVSubmitError) {
          debugPrint('❌ CV Submit Error: ${state.error}');

          setState(() {
            _isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Gagal menyimpan CV: ${state.error}',
                      style: primaryTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Coba Lagi',
                textColor: Colors.white,
                onPressed: _handleSubmit,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            SafeArea(
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
                      "Bagian Tambahan",
                      style: primaryTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tambahkan sertifikasi, bahasa, penghargaan, atau detail lain yang relevan.",
                      style: secondaryTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildMainCategoryCard(
                              icon: Icons.language,
                              title: "Bahasa",
                              desc: "Tambahkan bahasa yang Anda kuasai.",
                              itemCount: languageControllers.length,
                              expanded: showLanguage,
                              onToggle: () =>
                                  setState(() => showLanguage = !showLanguage),
                              onDeleteCategory: clearLanguage,
                              children: showLanguage
                                  ? List.generate(
                                      languageControllers.length,
                                      (i) => buildLanguageItem(i),
                                    )
                                  : [],
                              addButtonLabel: "+ Tambah Bahasa",
                              onAdd: showLanguage ? addLanguage : null,
                            ),
                            const SizedBox(height: 16),
                            buildMainCategoryCard(
                              icon: Icons.badge_outlined,
                              title: "Sertifikasi dan lisensi",
                              desc:
                                  "Tambahkan kredensial yang mendukung keahlian Anda.",
                              itemCount: certControllers.length,
                              expanded: showCert,
                              onToggle: () =>
                                  setState(() => showCert = !showCert),
                              onDeleteCategory: clearCert,
                              children: showCert
                                  ? List.generate(
                                      certControllers.length,
                                      (i) => buildItemField(
                                        controller: certControllers[i],
                                        onDelete: () => removeCert(i),
                                        hint: "Nama Sertifikasi",
                                      ),
                                    )
                                  : [],
                              addButtonLabel: "+ Tambah Sertifikasi",
                              onAdd: showCert ? addCert : null,
                            ),
                            const SizedBox(height: 16),
                            buildMainCategoryCard(
                              icon: Icons.emoji_events_outlined,
                              title: "Penghargaan dan apresiasi",
                              desc: "Bagikan pencapaian Anda.",
                              itemCount: awardControllers.length,
                              expanded: showAward,
                              onToggle: () =>
                                  setState(() => showAward = !showAward),
                              onDeleteCategory: clearAward,
                              children: showAward
                                  ? List.generate(
                                      awardControllers.length,
                                      (i) => buildItemField(
                                        controller: awardControllers[i],
                                        onDelete: () => removeAward(i),
                                        hint: "Nama Penghargaan",
                                      ),
                                    )
                                  : [],
                              addButtonLabel: "+ Tambah Penghargaan",
                              onAdd: showAward ? addAward : null,
                            ),
                            const SizedBox(height: 16),
                            buildMainCategoryCard(
                              icon: Icons.link_outlined,
                              title: "Situs Web dan media sosial",
                              desc: "LinkedIn, Portofolio, Github, dll.",
                              expanded: showLink,
                              onToggle: () =>
                                  setState(() => showLink = !showLink),
                              onDeleteCategory: clearLink,
                              itemCount: linkControllers.length,
                              children: showLink
                                  ? List.generate(
                                      linkControllers.length,
                                      (i) => buildItemField(
                                        controller: linkControllers[i],
                                        onDelete: () => removeLink(i),
                                        hint: "URL / Username",
                                      ),
                                    )
                                  : [],
                              addButtonLabel: "+ Tambah Link",
                              onAdd: showLink ? addLink : null,
                            ),
                            const SizedBox(height: 16),
                            buildMainCategoryCard(
                              icon: Icons.widgets_outlined,
                              title: "Kustom",
                              desc: "Tambahkan informasi tambahan lainnya",
                              expanded: showCustom,
                              onToggle: () =>
                                  setState(() => showCustom = !showCustom),
                              onDeleteCategory: clearCustom,
                              itemCount: customControllers.length,
                              children: showCustom
                                  ? List.generate(
                                      customControllers.length,
                                      (i) => buildItemField(
                                        controller: customControllers[i],
                                        onDelete: () => removeCustom(i),
                                        hint: "Teks Kustom",
                                      ),
                                    )
                                  : [],
                              addButtonLabel: "+ Tambah Kustom",
                              onAdd: showCustom ? addCustom : null,
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

            // Loading Overlay
            if (_isSubmitting)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            bluePrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Menyimpan Data...',
                          style: primaryTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mohon tunggu sebentar',
                          style: secondaryTextStyle.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: _isSubmitting
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: CustomFilledButton(
                    title: "Periksa",
                    variant: ButtonColorVariant.blue,
                    onPressed: _handleSubmit,
                  ),
                ),
              ),
      ),
    );
  }

  void _handleSubmit() {
    if (_isSubmitting) {
      debugPrint('⚠️ Submit already in progress, ignoring...');
      return;
    }

    debugPrint('🔵 Periksa button pressed');

    final languages = List.generate(languageControllers.length, (index) {
      final languageName = languageControllers[index].text;
      if (languageName.isNotEmpty) {
        return CVBahasa(
          namaBahasa: languageName,
          level: index < levels.length ? levels[index] : 1,
        );
      }
      return null;
    }).whereType<CVBahasa>().toList();

    final certifications = certControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => CVSertifikasi(namaSertifikasi: controller.text))
        .toList();

    final awards = awardControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => CVPenghargaan(namaPenghargaan: controller.text))
        .toList();

    final socialMedia = linkControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) {
          final link = controller.text;
          String platformName = "Website";
          if (link.contains("linkedin"))
            platformName = "LinkedIn";
          else if (link.contains("github"))
            platformName = "GitHub";
          else if (link.contains("twitter"))
            platformName = "Twitter";
          else if (link.contains("instagram"))
            platformName = "Instagram";

          return CVMediaSosial(
            namaMediaSosial: platformName,
            linkMediaSosial: link,
          );
        })
        .toList();

    debugPrint('📊 Data collected:');
    debugPrint('  - Languages: ${languages.length}');
    debugPrint('  - Certifications: ${certifications.length}');
    debugPrint('  - Awards: ${awards.length}');
    debugPrint('  - Social Media: ${socialMedia.length}');

    // Update additional data first
    context.read<BuildCVBloc>().add(
      UpdateAdditionalData(
        languages: languages,
        certifications: certifications,
        awards: awards,
        socialMedia: socialMedia,
      ),
    );

    // Wait a bit to ensure data is updated in bloc
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && !_isSubmitting) {
        debugPrint('🚀 Submitting CV...');
        context.read<BuildCVBloc>().add(SubmitCV());
      }
    });
  }

  Widget buildMainCategoryCard({
    required IconData icon,
    required String title,
    required String desc,
    required int itemCount,
    required List<Widget> children,
    required String addButtonLabel,
    required VoidCallback? onAdd,
    required VoidCallback onDeleteCategory,
    bool expanded = true,
    VoidCallback? onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: thirdColor, width: 1.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: bluePrimaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: primaryTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: secondaryTextStyle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (onToggle != null)
                InkWell(
                  onTap: onToggle,
                  child: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: bluePrimaryColor,
                    size: 28,
                  ),
                ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onDeleteCategory,
                child: Icon(
                  Icons.delete_outline,
                  color: bluePrimaryColor,
                  size: 24,
                ),
              ),
            ],
          ),
          if (expanded && children.isNotEmpty) ...[
            const SizedBox(height: 20),
            ...children,
          ],
          if (expanded && onAdd != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: onAdd,
              child: Text(
                addButtonLabel,
                style: primaryTextStyle.copyWith(
                  color: bluePrimaryColor,
                  fontWeight: semiBold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildLanguageItem(int index) {
    final safeLevel = (index < levels.length) ? levels[index] : 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Keterampilan",
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: languageControllers[index],
            decoration: InputDecoration(
              hintText: "Indonesia",
              hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: thirdColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: thirdColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: bluePrimaryColor, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Level — ",
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: getLevelName(safeLevel),
                  style: secondaryTextStyle.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: buildLevelSlider(index)),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => removeLanguage(index),
                child: Icon(
                  Icons.delete_outline,
                  color: bluePrimaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildItemField({
    required TextEditingController controller,
    required VoidCallback onDelete,
    required String hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF8FAFB),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: thirdColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: thirdColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: bluePrimaryColor, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            child: Icon(
              Icons.delete_outline,
              color: bluePrimaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLevelSlider(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = 50.0;

        return GestureDetector(
          onTapDown: (details) {
            double relative = (details.localPosition.dx / width).clamp(0, 1);
            setState(() {
              if (index < levels.length) {
                levels[index] = (relative * 5).clamp(1, 5).round();
              }
            });
          },
          onHorizontalDragUpdate: (details) {
            double relative = (details.localPosition.dx / width).clamp(0, 1);
            setState(() {
              if (index < levels.length) {
                levels[index] = (relative * 5).clamp(1, 5).round();
              }
            });
          },
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: (levels[index] / 5) * width,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: bluePrimaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Container(
                      width: width / 5,
                      height: barHeight,
                      decoration: BoxDecoration(
                        border: i == 0
                            ? null
                            : Border(
                                left: BorderSide(
                                  color: Colors.white.withOpacity(0.45),
                                  width: 1,
                                ),
                              ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
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
        return "Pemula";
    }
  }
}
