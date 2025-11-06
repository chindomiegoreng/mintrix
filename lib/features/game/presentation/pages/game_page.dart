import 'package:flutter/material.dart';
import 'game_detail_page.dart';

class GamePage extends StatelessWidget {
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
                  0.2,
                  false,
                  "modul1",
                  "bagian1",
                ),
                _buildSection(
                  context,
                  "Bagian 2",
                  "Pemetaan bakat dan kompetensi",
                  0.0,
                  true,
                  "modul1",
                  "bagian2",
                ),
                _buildSection(
                  context,
                  "Bagian 3",
                  "Berkomunikasi",
                  0.0,
                  true,
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
                  0.2,
                  false,
                  "modul2",
                  "bagian1",
                ),
                _buildSection(
                  context,
                  "Bagian 2",
                  "Personal branding",
                  0.0,
                  true,
                  "modul2",
                  "bagian2",
                ),
                _buildSection(
                  context,
                  "Bagian 3",
                  "Wawancara kerja",
                  0.0,
                  true,
                  "modul2",
                  "bagian3",
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
        const Icon(Icons.local_fire_department, color: Colors.grey, size: 22),
        const SizedBox(width: 4),
        Text(
          streak.toString(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        const Icon(Icons.ac_unit, color: Colors.lightBlueAccent, size: 22),
        const SizedBox(width: 4),
        Text(
          gems.toString(),
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          "XP $xp",
          style: const TextStyle(
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildModule(BuildContext context, String title, List<Widget> sections) {
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
          ? null
          : () {
              Navigator.push(
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