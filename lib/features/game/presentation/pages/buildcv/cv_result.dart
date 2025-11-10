import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/game/bloc/build_cv_bloc.dart';
import 'package:mintrix/features/game/presentation/pages/level_journey_page.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class CVResult extends StatefulWidget {
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
  State<CVResult> createState() => _CVResultState();
}

class _CVResultState extends State<CVResult> {
  String? resumeId;
  String? resumeLink;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuildCVBloc, BuildCVState>(
      listener: (context, state) {
        if (state is CVSubmitSuccess) {
          setState(() {
            resumeId = state.cvModel.id;
            resumeLink = state.cvModel.resumeLink;
            isLoading = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resume berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CVSubmitError) {
          setState(() {
            isLoading = false;
          });

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CVSubmitting) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CVDownloadSuccess) {
          setState(() {
            isLoading = false;
          });

          // Open download URL
          _launchURL(state.downloadUrl);
        } else if (state is CVDownloadError) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Download error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CVDownloading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Sedang memproses...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          resumeId != null
                              ? "Yeay, AI Sudah Selesai Generate"
                              : "Sedang memproses CV Anda...",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
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
                const Text(
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
                        title: isLoading ? "Loading..." : "Download",
                        variant: ButtonColorVariant.white,
                        onPressed: isLoading || resumeId == null
                            ? null
                            : () {
                                if (resumeLink != null) {
                                  _launchURL(resumeLink!);
                                } else if (resumeId != null) {
                                  context.read<BuildCVBloc>().add(
                                    DownloadCV(resumeId!),
                                  );
                                }
                              },
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
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open download link: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
