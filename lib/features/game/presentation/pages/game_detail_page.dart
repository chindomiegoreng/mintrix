import 'package:flutter/material.dart';
import 'package:mintrix/features/game/presentation/pages/level_journey_page.dart';
import 'package:mintrix/widgets/buttons.dart';

class GameDetailPage extends StatefulWidget {
  final String sectionTitle;
  final double progress;

  const GameDetailPage({
    super.key,
    required this.sectionTitle,
    required this.progress,
  });

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GameHeader(),
            SectionProgressCard(
              title: "Bagian 1",
              subtitle: widget.sectionTitle,
              progress: widget.progress,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: const [
                  LessonCard(
                    title: "Mencari Hal Yang Kamu Suka",
                    dinoImage: "assets/images/dino_daily_mission.png",
                    locked: false,
                  ),
                  LessonCard(
                    title: "Mengatur Waktu",
                    dinoImage: "assets/images/dino_daily_mission.png",
                    locked: false,
                  ),
                  LessonCard(
                    title: "Berpikir Positif",
                    dinoImage: "assets/images/dino_daily_mission.png",
                    locked: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.lightBlue
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomFilledButton(
                title: "Mulai",
                variant: ButtonColorVariant.blue,
                height: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelJourneyPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          Row(
            children: const [
              Icon(Icons.local_fire_department, color: Colors.grey, size: 22),
              SizedBox(width: 4),
              Text(
                "4",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.ac_unit, color: Colors.lightBlueAccent, size: 22),
              SizedBox(width: 4),
              Text(
                "200",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Text(
            "XP 520",
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const SectionProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Stack(
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

class LessonCard extends StatelessWidget {
  final String title;
  final String dinoImage;
  final bool locked;

  const LessonCard({
    super.key,
    required this.title,
    required this.dinoImage,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(
              locked
                  ? "assets/images/modul_locked.png"
                  : "assets/images/modul_card.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ),
            if (!locked)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Image.asset(
                    dinoImage,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (locked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
