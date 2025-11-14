import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/game_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_detail_page.dart';

class GamePage extends StatefulWidget {
  final String userName;
  final int streak;
  final int gems;
  final int xp;

  const GamePage({
    super.key,
    required this.userName,
    required this.streak,
    required this.gems,
    required this.xp,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Map<String, bool> sectionLocked = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      sectionLocked['modul1_bagian1'] = false; // Selalu terbuka
      sectionLocked['modul1_bagian2'] =
          (prefs.getDouble('modul1_bagian1_progress') ?? 0.0) < 1.0;
      sectionLocked['modul1_bagian3'] =
          (prefs.getDouble('modul1_bagian2_progress') ?? 0.0) < 1.0;
      sectionLocked['modul2_bagian1'] = false; // Langsung terbuka
      sectionLocked['modul2_bagian2'] =
          (prefs.getDouble('modul2_bagian1_progress') ?? 0.0) < 1.0;
      sectionLocked['modul2_bagian3'] =
          (prefs.getDouble('modul2_bagian2_progress') ?? 0.0) < 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GameHeaderWidget(),
              const SizedBox(height: 24),
              _buildModule(context, "Modul 1", [
                _buildSection(
                  context,
                  "Bagian 1",
                  "Mencari minat dan gairah",
                  sectionLocked['modul1_bagian1'] ?? false,
                  "modul1",
                  "bagian1",
                ),
                _buildSection(
                  context,
                  "Bagian 2",
                  "Pemetaan bakat dan kompetensi",
                  sectionLocked['modul1_bagian2'] ?? true,
                  "modul1",
                  "bagian2",
                ),
                _buildSection(
                  context,
                  "Bagian 3",
                  "Berkomunikasi",
                  sectionLocked['modul1_bagian3'] ?? true,
                  "modul1",
                  "bagian3",
                ),
              ]),
              const SizedBox(height: 20),
              _buildModule(context, "Modul 2", [
                _buildSection(
                  context,
                  "Bagian 1",
                  "Persiapan karir",
                  sectionLocked['modul2_bagian1'] ?? true,
                  "modul2",
                  "bagian1",
                ),
                // _buildSection(
                //   context,
                //   "Bagian 2",
                //   "Personal branding",
                //   sectionLocked['modul2_bagian2'] ?? true,
                //   "modul2",
                //   "bagian2",
                // ),
                // _buildSection(
                //   context,
                //   "Bagian 3",
                //   "Wawancara kerja",
                //   sectionLocked['modul2_bagian3'] ?? true,
                //   "modul2",
                //   "bagian3",
                // ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModule(
    BuildContext context,
    String title,
    List<Widget> sections,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
        ),
        const SizedBox(height: 10),
        ...sections,
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String subtitle,
    bool locked,
    String moduleId,
    String sectionId,
  ) {
    return GestureDetector(
      onTap: locked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Selesaikan bagian sebelumnya terlebih dahulu!',
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          : () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameDetailPage(
                    sectionTitle: subtitle,
                    progress:
                        0.0, // Default value since we removed progress tracking
                    moduleId: moduleId,
                    sectionId: sectionId,
                  ),
                ),
              );

              // Reload progress setelah kembali dari detail page
              if (result == true) {
                _loadProgress();
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: bluePrimaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ),
            locked
                ? const Icon(Icons.lock, color: Colors.grey)
                : const Icon(Icons.chevron_right, color: Colors.lightBlue),
          ],
        ),
      ),
    );
  }
}
