import 'package:flutter/material.dart';
import 'package:mintrix/features/game/presentation/pages/level_journey_page.dart';
import 'package:mintrix/widgets/buttons.dart';

class CVResult extends StatelessWidget {
  final VoidCallback onComplete;
  final VoidCallback onDownload;
  final VoidCallback onBack;

  const CVResult({
    super.key,
    required this.onComplete,
    required this.onDownload,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),

                const Text(
                  "Yeay, AI Sudah Selesai Generate",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      "assets/images/home_card_large.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 141, 224, 245),
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🎉 Wow, kamu super duper kece xp+20",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomFilledButton(
                      title: "Download",
                      variant: ButtonColorVariant.white,
                      onPressed: onDownload,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomFilledButton(
                      title: "Selanjutnya",
                      variant: ButtonColorVariant.blue,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LevelJourneyPage(
                              moduleId: "modul2",
                              sectionId: "bagian1",
                              lessonIndex: 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
