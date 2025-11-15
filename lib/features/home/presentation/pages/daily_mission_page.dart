import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/features/ai/presentation/pages/ai_page.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class DailyMissionPage extends StatefulWidget {
  const DailyMissionPage({super.key});

  @override
  State<DailyMissionPage> createState() => _DailyMissionPageState();
}

class _DailyMissionPageState extends State<DailyMissionPage> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  String? _errorMessage;

  // Mission data
  bool _ajakNgobrolDino = false;
  bool _lakukanHobimuHariIni = false;
  bool _hubungkanAkunmuDenganOrangTua = false;
  int _currentPoint = 0;
  String _lastResetDaily = '';

  @override
  void initState() {
    super.initState();
    _fetchMissionData();
  }

  // ======================================
  // FETCH MISSION DATA
  // ======================================
  Future<void> _fetchMissionData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiClient.get(
        ApiEndpoints.mission,
        requiresAuth: true,
      );

      if (response['data'] != null) {
        final missionData = response['data'];

        setState(() {
          _ajakNgobrolDino = missionData['ajakNgobrolDino'] ?? false;
          _lakukanHobimuHariIni = missionData['lakukanHobimuHariIni'] ?? false;
          _hubungkanAkunmuDenganOrangTua =
              missionData['hubungkanAkunmuDenganOrangTua'] ?? false;
          _currentPoint = missionData['point'] ?? 0;
          _lastResetDaily = missionData['lastResetDailyWIB'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data misi: $e';
      });
    }
  }

  // ======================================
  // UPDATE MISSION STATUS
  // ======================================
  Future<void> _updateMissionStatus(String missionType) async {
    try {
      Map<String, dynamic> body = {};

      switch (missionType) {
        case 'dino':
          body = {'ajakNgobrolDino': true};
          break;
        case 'hobby':
          body = {'lakukanHobimuHariIni': true};
          break;
        case 'connect':
          body = {'hubungkanAkunmuDenganOrangTua': true};
          break;
      }

      final response = await _apiClient.patch(
        ApiEndpoints.mission,
        body: body,
        requiresAuth: true,
      );

      if (response['data'] != null) {
        final updatedMission = response['data'];

        setState(() {
          _ajakNgobrolDino = updatedMission['ajakNgobrolDino'] ?? false;
          _lakukanHobimuHariIni =
              updatedMission['lakukanHobimuHariIni'] ?? false;
          _hubungkanAkunmuDenganOrangTua =
              updatedMission['hubungkanAkunmuDenganOrangTua'] ?? false;
          _currentPoint = updatedMission['point'] ?? 0;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Misi berhasil diselesaikan! 🎉'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyelesaikan misi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ==============================================================
  // ⭐ POPUP KONFIRMASI – khusus "Lakukan hobimu hari ini"
  // ==============================================================
  Future<void> _showConfirmHobbyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Konfirmasi",
                  style: primaryTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  "Sudah melakukan hobimu hari ini?",
                  style: secondaryTextStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side:
                              const BorderSide(color: Color(0xff4DD4E8), width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Belum",
                          style: bluePrimaryTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _updateMissionStatus('hobby');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4DD4E8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Ya",
                          style: whiteTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ==============================================================
  // BUTTON MISI
  // ==============================================================
  Widget _buildMissionButton(String mission, bool isCompleted) {
    if (isCompleted) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 28);
    }

    return ElevatedButton(
      onPressed: () async {
        if (mission == 'dino') {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIPage()),
          );
          await _updateMissionStatus('dino');
          return;
        }

        if (mission == 'hobby') {
          await _showConfirmHobbyDialog();
          return;
        }

        await _updateMissionStatus(mission);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff4DD4E8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      child: Text(
        "Mulai",
        style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
      ),
    );
  }

  // ==============================================================
  // MAIN UI
  // ==============================================================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_daily_mission.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_daily_mission.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage!,
                  style: primaryTextStyle.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchMissionData,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final double progress = _calculateProgress();

    return Scaffold(
      body: Container(
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
                child: RefreshIndicator(
                  onRefresh: _fetchMissionData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "November",
                                    style: primaryTextStyle.copyWith(
                                      fontWeight: medium,
                                      fontSize: 16,
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
                                    const Icon(Icons.star,
                                        color: Colors.orange, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      "$_currentPoint POIN",
                                      style: secondaryTextStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: semiBold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CachedNetworkImage(
                              imageUrl:
                                  'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846605/character15_pet4at.png',
                              width: 100,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // PROGRESS
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
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

                        // TITLE MISI
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
                            Text(
                              _lastResetDaily.isNotEmpty
                                  ? _lastResetDaily
                                  : 'Hari ini',
                              style: bluePrimaryTextStyle.copyWith(
                                fontWeight: semiBold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // LIST MISI
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
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
                                trailing:
                                    _buildMissionButton('dino', _ajakNgobrolDino),
                              ),
                              const Divider(height: 24),
                              _buildMissionItem(
                                title: "Lakukan hobimu hari ini",
                                trailing: _buildMissionButton(
                                    'hobby', _lakukanHobimuHariIni),
                              ),
                              const Divider(height: 24),
                              _buildMissionItem(
                                title: "Hubungkan akunmu dengan orang tua",
                                trailing: _buildMissionButton(
                                    'connect', _hubungkanAkunmuDenganOrangTua),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // BUTTON KEMBALI
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

  // ==============================================================
  // PROGRESS BAR
  // ==============================================================
  double _calculateProgress() {
    int completedCount = 0;
    if (_ajakNgobrolDino) completedCount++;
    if (_lakukanHobimuHariIni) completedCount++;
    if (_hubungkanAkunmuDenganOrangTua) completedCount++;

    return completedCount / 3;
  }

  Widget _buildProgressBarWithCheckpoints(double progress) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                  ),
                ),
              ),
            ),
          ),
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

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }
}
