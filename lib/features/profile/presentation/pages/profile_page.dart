import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:radar_chart/radar_chart.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile saat page dibuka
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildLoadingState();
          } else if (state is ProfileLoaded) {
            return _buildLoadedState(state);
          } else if (state is ProfileError) {
            return _buildErrorState(state.message);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/profile_background.png",
            fit: BoxFit.cover,
          ),
        ),
        Center(child: CircularProgressIndicator(color: bluePrimaryColor)),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/profile_background.png",
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
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
        ),
      ],
    );
  }

  Widget _buildLoadedState(ProfileLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(RefreshProfile());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Stack(
        children: [
          // bg
          Positioned.fill(
            child: Image.asset(
              "assets/images/profile_background.png",
              fit: BoxFit.cover,
            ),
          ),
          // container white
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 423,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          // konten scroll
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 98),
              _profileInfo(state),
              _statsRow(state),
              _achievementsContainer(),
              _progressContainer(context),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileInfo(ProfileLoaded state) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          // ✅ Dynamic profile photo
          state.foto != null && state.foto!.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: state.foto!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                ),
          const SizedBox(height: 14),
          // ✅ Dynamic name
          Text(
            state.name,
            style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          const SizedBox(height: 6),
          // ✅ Dynamic ID
          Text(
            "ID: ${state.id}",
            style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(ProfileLoaded state) {
    return Container(
      height: 117,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/home_card_asset.png", height: 36),
              const SizedBox(height: 2),
              Text(
                "Liga",
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 2),
              // ✅ Dynamic liga
              Text(
                state.liga,
                style: TextStyle(
                  color: _getLigaColor(state.liga),
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          VerticalDivider(
            color: bluePrimaryColor,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/xp.png", height: 36),
              const SizedBox(height: 2),
              Text(
                "Total XP",
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 2),
              // ✅ Dynamic XP
              Text(
                "${state.xp}",
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
          VerticalDivider(
            color: bluePrimaryColor,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/fire.png", height: 36),
              const SizedBox(height: 2),
              Text(
                "Runtutan",
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 2),
              // ✅ Dynamic streak
              Text(
                "${state.streakCount}",
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLigaColor(String? liga) {
    switch (liga?.toLowerCase()) {
      case 'emas':
      case 'gold':
        return const Color(0xffFFC800);
      case 'perak':
      case 'silver':
        return const Color(0xffC0C0C0);
      case 'perunggu':
      case 'bronze':
        return const Color(0xffCD7F32);
      default:
        return const Color(0xffFFC800);
    }
  }

  Widget _achievementsContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pencapaian",
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                "Lihat Detail",
                style: secondaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
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
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                Image.asset("assets/images/pencapaian1.png"),
                Image.asset("assets/images/pencapaian2.png"),
                Image.asset("assets/images/pencapaian3.png"),
                Image.asset("assets/images/pencapaian4.png"),
                Image.asset("assets/images/pencapaian5.png"),
                Image.asset("assets/images/pencapaian6.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressContainer(BuildContext context) {
    final labels = [
      "Berani",
      "Empati",
      "Tanggung Jawab",
      "Kerja Sama",
      "Kreativitas",
    ];
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Perkembangan",
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/detail-profile");
                },
                child: Text(
                  "Lihat Detail",
                  style: secondaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                      values: [0.4, 0.8, 0.65, 0.7, 0.5],
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
}
