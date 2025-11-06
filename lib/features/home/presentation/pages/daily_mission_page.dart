import 'package:flutter/material.dart';
import 'package:mintrix/features/ai/presentation/pages/ai_page.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

enum MissionStatus { notStarted, inProgress, completed }

class DailyMissionPage extends StatefulWidget {
  const DailyMissionPage({super.key});

  @override
  State<DailyMissionPage> createState() => _DailyMissionPageState();
}

class _DailyMissionPageState extends State<DailyMissionPage> {
  MissionStatus _dinoMissionStatus = MissionStatus.notStarted;
  MissionStatus _hobbyMissionStatus = MissionStatus.notStarted;
  MissionStatus _connectMissionStatus = MissionStatus.notStarted;

  void _updateMissionStatus(String mission) {
    setState(() {
      switch (mission) {
        case 'dino':
          if (_dinoMissionStatus == MissionStatus.notStarted) {
            _dinoMissionStatus = MissionStatus.inProgress;
          } else if (_dinoMissionStatus == MissionStatus.inProgress) {
            _dinoMissionStatus = MissionStatus.completed;
          }
          break;

        case 'hobby':
          if (_hobbyMissionStatus == MissionStatus.notStarted) {
            _hobbyMissionStatus = MissionStatus.inProgress;
          } else if (_hobbyMissionStatus == MissionStatus.inProgress) {
            _hobbyMissionStatus = MissionStatus.completed;
          }
          break;

        case 'connect':
          if (_connectMissionStatus == MissionStatus.notStarted) {
            _connectMissionStatus = MissionStatus.inProgress;
          } else if (_connectMissionStatus == MissionStatus.inProgress) {
            _connectMissionStatus = MissionStatus.completed;
          }
          break;
      }
    });
  }

  double _calculateProgress() {
    int completedCount = 0;
    if (_dinoMissionStatus == MissionStatus.completed) completedCount++;
    if (_hobbyMissionStatus == MissionStatus.completed) completedCount++;
    if (_connectMissionStatus == MissionStatus.completed) completedCount++;

    return completedCount / 3; // total 3 misi
  }

  Widget _buildMissionButton(String mission, MissionStatus status) {
    switch (status) {
      case MissionStatus.notStarted:
        return ElevatedButton(
          onPressed: () {
            if (mission == 'dino') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIPage()),
              );
            }
            _updateMissionStatus(mission);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff4DD4E8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          ),
          child: const Text("Mulai", style: TextStyle(color: Colors.white)),
        );

      case MissionStatus.inProgress:
        return ElevatedButton(
          onPressed: () => _updateMissionStatus(mission),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff4DD4E8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
          child: const Text("Selesai", style: TextStyle(color: Colors.white)),
        );

      case MissionStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green, size: 28);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _calculateProgress();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_daily_mission.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === Header ===
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "September",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Misi Harian",
                                style: primaryTextStyle.copyWith(
                                  fontSize: 28,
                                  fontWeight: bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    color: Color(0xff6B7280),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "20 HARI",
                                    style: secondaryTextStyle.copyWith(
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Flexible(
                            child: Image.asset(
                              'assets/images/dino_daily_mission.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // === Progress Bar ===
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${(progress * 100).toInt()}% Selesai",
                              style: secondaryTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildProgressBarWithCheckpoints(progress),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // === Mission List ===
                      Row(
                        children: [
                          Text(
                            "Misi Harian",
                            style: primaryTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: bold,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.access_time,
                            color: Color(0xff4DD4E8),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "6 JAM",
                            style: bluePrimaryTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xffE0E7FF).withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildMissionItem(
                              title: "Ajak ngobrol dino",
                              trailing: _buildMissionButton(
                                'dino',
                                _dinoMissionStatus,
                              ),
                            ),
                            const Divider(height: 24),
                            _buildMissionItem(
                              title: "Lakukan hobimu hari ini",
                              trailing: _buildMissionButton(
                                'hobby',
                                _hobbyMissionStatus,
                              ),
                            ),
                            const Divider(height: 24),
                            _buildMissionItem(
                              title: "Hubungkan akunmu dengan orang tua",
                              trailing: _buildMissionButton(
                                'connect',
                                _connectMissionStatus,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // === Tombol Kembali di bawah ===
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: CustomFilledButton(
                  title: "Kembali",
                  variant: ButtonColorVariant.blue,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBarWithCheckpoints(double progress) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // background
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // progress
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff4DD4E8), Color(0xff3BBDD4)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff4DD4E8).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // checkpoints
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCheckpoint(isCompleted: progress >= 1 / 3),
                _buildCheckpoint(isCompleted: progress >= 2 / 3),
                _buildCheckpoint(isCompleted: progress >= 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckpoint({required bool isCompleted}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? const Color(0xff4DD4E8) : const Color(0xffD1D5DB),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Center(
        child: Icon(
          isCompleted ? Icons.check : Icons.lock,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMissionItem({required String title, required Widget trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing,
      ],
    );
  }
}
