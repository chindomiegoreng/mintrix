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
  
  // Mission data from API
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

  // ✅ Fetch mission data from API
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
          _hubungkanAkunmuDenganOrangTua = missionData['hubungkanAkunmuDenganOrangTua'] ?? false;
          _currentPoint = missionData['point'] ?? 0;
          _lastResetDaily = missionData['lastResetDailyWIB'] ?? '';
          _isLoading = false;
        });
        
        print('✅ Mission data loaded successfully');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data misi: $e';
      });
      print('❌ Failed to fetch mission data: $e');
    }
  }

  // ✅ Update mission status via API - menggunakan 1 endpoint dengan body berbeda
  Future<void> _updateMissionStatus(String missionType) async {
    try {
      Map<String, dynamic> body = {};
      
      // Tentukan field mana yang akan diupdate
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
        // ✅ Update local state dengan data dari API
        final updatedMission = response['data'];
        setState(() {
          _ajakNgobrolDino = updatedMission['ajakNgobrolDino'] ?? false;
          _lakukanHobimuHariIni = updatedMission['lakukanHobimuHariIni'] ?? false;
          _hubungkanAkunmuDenganOrangTua = updatedMission['hubungkanAkunmuDenganOrangTua'] ?? false;
          _currentPoint = updatedMission['point'] ?? 0;
        });
        
        print('✅ Mission updated successfully');
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Misi berhasil diselesaikan! 🎉'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Failed to update mission: $e');
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

  double _calculateProgress() {
    int completedCount = 0;
    if (_ajakNgobrolDino) completedCount++;
    if (_lakukanHobimuHariIni) completedCount++;
    if (_hubungkanAkunmuDenganOrangTua) completedCount++;

    return completedCount / 3; // total 3 misi
  }

  Widget _buildMissionButton(String mission, bool isCompleted) {
    if (isCompleted) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 28);
    }

    return ElevatedButton(
      onPressed: () async {
        if (mission == 'dino') {
          // Navigate to AI Page first
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIPage()),
          );
        }
        // Update mission status
        await _updateMissionStatus(mission);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff4DD4E8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      child: const Text("Mulai", style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
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
                child: RefreshIndicator(
                  onRefresh: _fetchMissionData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                                    "November",
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
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "$_currentPoint POIN",
                                      style: secondaryTextStyle.copyWith(
                                          fontSize: 16, fontWeight: semiBold),
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
                            Text(
                              _lastResetDaily.isNotEmpty ? _lastResetDaily : 'Hari ini',
                              style: bluePrimaryTextStyle.copyWith(
                                fontWeight: semiBold,
                                fontSize: 12,
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
                                  _ajakNgobrolDino,
                                ),
                              ),
                              const Divider(height: 24),
                              _buildMissionItem(
                                title: "Lakukan hobimu hari ini",
                                trailing: _buildMissionButton(
                                  'hobby',
                                  _lakukanHobimuHariIni,
                                ),
                              ),
                              const Divider(height: 24),
                              _buildMissionItem(
                                title: "Hubungkan akunmu dengan orang tua",
                                trailing: _buildMissionButton(
                                  'connect',
                                  _hubungkanAkunmuDenganOrangTua,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // === Tombol Kembali di bawah ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }
}