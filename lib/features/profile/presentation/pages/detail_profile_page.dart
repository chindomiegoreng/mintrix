import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ Add this
import 'package:mintrix/shared/theme.dart';
import 'package:radar_chart/radar_chart.dart';
import '../bloc/profile_bloc.dart'; // ✅ Add this
import '../bloc/profile_event.dart'; // ✅ Add this
import '../bloc/profile_state.dart'; // ✅ Add this

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  @override
  void initState() {
    super.initState();
    // ✅ Load profile using bloc (same as Profile Page)
    context.read<ProfileBloc>().add(LoadProfile());
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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: primaryTextStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(LoadProfile());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(RefreshProfile());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _profileInfo(state),
                  const SizedBox(height: 20),
                  _sectionTitle1(),
                  _progressContainer(state),
                  const SizedBox(height: 12),
                  _sectionTitle2(state),
                  const SizedBox(height: 50),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _profileInfo(ProfileLoaded state) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          // ✅ Dynamic photo from bloc
          state.foto != null && state.foto!.isNotEmpty
              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: CachedNetworkImageProvider(state.foto!),
                )
              : const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
          const SizedBox(height: 14),
          // ✅ Dynamic name from bloc
          Text(
            state.name,
            style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          const SizedBox(height: 6),
          // ✅ Dynamic ID from bloc
          Text(
            // "ID: ${state.id.substring(state.id.length - 10)}",
            "ID: ${state.id}",
            style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle1() {
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

  Widget _progressContainer(ProfileLoaded state) {
    final labels = [
      "Berani",
      "Empati",
      "Tanggung Jawab",
      "Kerja Sama",
      "Kreativitas",
    ];

    // ✅ Get radar values from bloc state (same as Profile Page)
    final radarValues =
        state.personality?.toRadarValues() ?? [0.0, 0.0, 0.0, 0.0, 0.0];

    print('🎨 Detail Profile Radar Values: $radarValues'); // ✅ Debug log

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
                      values: radarValues, // ✅ Same source as Profile Page
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

  Widget _sectionTitle2(ProfileLoaded state) {
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
        // ✅ Dynamic hobi dan minat from bloc
        Text(
          state.personality?.hobiDanMinat.isNotEmpty ?? false
              ? state.personality!.hobiDanMinat
              : "Belum ada data hobi dan minat.",
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ],
    );
  }
}
