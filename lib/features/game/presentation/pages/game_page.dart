import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_state.dart';
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
  Map<String, double> sectionProgress = {};
  Map<String, bool> sectionLocked = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      sectionProgress['modul1_bagian1'] =
          prefs.getDouble('modul1_bagian1_progress') ?? 0.0;
      sectionProgress['modul1_bagian2'] =
          prefs.getDouble('modul1_bagian2_progress') ?? 0.0;
      sectionProgress['modul1_bagian3'] =
          prefs.getDouble('modul1_bagian3_progress') ?? 0.0;
      sectionProgress['modul2_bagian1'] =
          prefs.getDouble('modul2_bagian1_progress') ?? 0.0;
      sectionProgress['modul2_bagian2'] =
          prefs.getDouble('modul2_bagian2_progress') ?? 0.0;
      sectionProgress['modul2_bagian3'] =
          prefs.getDouble('modul2_bagian3_progress') ?? 0.0;

      sectionLocked['modul1_bagian1'] = false; // Selalu terbuka
      sectionLocked['modul1_bagian2'] =
          (sectionProgress['modul1_bagian1'] ?? 0.0) < 1.0;
      sectionLocked['modul1_bagian3'] =
          (sectionProgress['modul1_bagian2'] ?? 0.0) < 1.0;
      sectionLocked['modul2_bagian1'] = false; // Langsung terbuka
      sectionLocked['modul2_bagian2'] =
          (sectionProgress['modul2_bagian1'] ?? 0.0) < 1.0;
      sectionLocked['modul2_bagian3'] =
          (sectionProgress['modul2_bagian2'] ?? 0.0) < 1.0;
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
              _buildHeader(),
              const SizedBox(height: 24),
              _buildModule(context, "Modul 1", [
                _buildSection(
                  context,
                  "Bagian 1",
                  "Mencari minat dan gairah",
                  sectionProgress['modul1_bagian1'] ?? 0.0,
                  sectionLocked['modul1_bagian1'] ?? false,
                  "modul1",
                  "bagian1",
                ),
                _buildSection(
                  context,
                  "Bagian 2",
                  "Pemetaan bakat dan kompetensi",
                  sectionProgress['modul1_bagian2'] ?? 0.0,
                  sectionLocked['modul1_bagian2'] ?? true,
                  "modul1",
                  "bagian2",
                ),
                _buildSection(
                  context,
                  "Bagian 3",
                  "Berkomunikasi",
                  sectionProgress['modul1_bagian3'] ?? 0.0,
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
                  sectionProgress['modul2_bagian1'] ?? 0.0,
                  sectionLocked['modul2_bagian1'] ?? true,
                  "modul2",
                  "bagian1",
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        const Spacer(),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            int streakCount = 0;
            
            if (profileState is ProfileLoaded) {
              streakCount = profileState.streakCount;
            }
            
            return Row(
              children: [
               Image.asset("assets/icons/fire.png", height: 36),
                const SizedBox(width: 4),
                Text(
                  "$streakCount",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            );
          },
        ),
        const Spacer(),
        Row(
          children: [
            Image.asset("assets/icons/icon_diamond.png", height: 36),
            const SizedBox(width: 4),
            const Text(
              "500",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            int xpCount = 0;
            
            if (profileState is ProfileLoaded) {
              xpCount = profileState.xp;
            }
            
            return Text(
              "XP $xpCount",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
      ],
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    double progress,
    bool locked,
    String moduleId,
    String sectionId,
  ) {
    return GestureDetector(
      onTap: locked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Selesaikan bagian sebelumnya terlebih dahulu!',
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
                    progress: progress,
                    moduleId: moduleId,
                    sectionId: sectionId,
                  ),
                ),
              );
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            locked
                ? const Icon(Icons.lock, color: Colors.grey)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          color: Colors.lightBlue,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}