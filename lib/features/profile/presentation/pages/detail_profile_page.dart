import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/profile_detail_model.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:radar_chart/radar_chart.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final ApiClient _apiClient = ApiClient();
  ProfileDetailModel? _profileDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileDetail();
  }

  Future<void> _loadProfileDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('📡 Loading profile detail...');

      final response = await _apiClient.get(
        ApiEndpoints.profileDetail,
        requiresAuth: true,
      );

      print('✅ Profile detail response: $response');

      final data = response['data'] ?? {};
      final profileDetail = ProfileDetailModel.fromJson(data);

      setState(() {
        _profileDetail = profileDetail;
        _isLoading = false;
      });

      print('🎉 Profile detail loaded: ${profileDetail.user.nama}');
    } catch (e) {
      print('❌ Profile detail error: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(_errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProfileDetail,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadProfileDetail,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  profileInfo(),
                  const SizedBox(height: 20),
                  sectionTitle1(),
                  progressContainer(),
                  const SizedBox(height: 12),
                  sectionTitle2(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget profileInfo() {
    if (_profileDetail == null) return const SizedBox();

    final user = _profileDetail!.user;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          // ✅ Dynamic photo
          user.foto != null && user.foto!.isNotEmpty
              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: CachedNetworkImageProvider(user.foto!),
                )
              : CircleAvatar(
                  radius: 60,
                  backgroundImage: const AssetImage(
                    "assets/images/profile.png",
                  ),
                ),
          const SizedBox(height: 14),
          // ✅ Dynamic name
          Text(
            user.nama,
            style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          const SizedBox(height: 6),
          // ✅ Dynamic ID
          Text(
            "ID: ${user.id.substring(user.id.length - 10)}",
            style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kepribadian Kamu",
          style: bluePrimaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Data di bawah ini merupakan rekam jejak penggunaan aplikasi dari awal hingga saat ini dan dapat berubah kapanpun. Penilaian yang ditampilkan didasarkan pada keseluruhan aktivitas anak.",
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ],
    );
  }

  Widget progressContainer() {
    if (_profileDetail == null) return const SizedBox();

    final personality = _profileDetail!.personality;
    final labels = [
      "Berani",
      "Empati",
      "Tanggung Jawab",
      "Kerja Sama",
      "Kreativitas",
    ];

    // ✅ Dynamic radar values
    final radarValues = personality.toRadarValues();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: bluePrimaryColor, width: 1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: bluePrimaryColor,
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadarChart(
                  length: 5,
                  radius: 90,
                  initialAngle: 0,
                  borderStroke: 2,
                  borderColor: thirdColor,
                  radialStroke: 1,
                  radialColor: thirdColor,
                  vertices: [
                    for (int i = 0; i < 5; i++)
                      PreferredSize(
                        preferredSize: const Size.fromRadius(15),
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            color: bluePrimaryColor,
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                  ],
                  radars: [
                    RadarTile(
                      values: radarValues, // ✅ Dynamic values from API
                      borderStroke: 2,
                      backgroundColor: greenColor.withAlpha(100),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle2() {
    if (_profileDetail == null) return const SizedBox();

    final personality = _profileDetail!.personality;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hobi dan Minat Kamu",
          style: bluePrimaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 8),
        // ✅ Dynamic hobi dan minat
        Text(
          personality.hobiDanMinat.isNotEmpty
              ? personality.hobiDanMinat
              : "Belum ada data hobi dan minat.",
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ],
    );
  }
}
