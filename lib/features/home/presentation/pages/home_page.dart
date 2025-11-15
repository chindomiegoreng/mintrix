import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mintrix/features/auth/presentation/bloc/auth_event.dart';
import 'package:mintrix/features/auth/presentation/bloc/auth_state.dart';
import 'package:mintrix/features/daily_notes/persentation/daily_notes_page.dart';
import 'package:mintrix/features/home/presentation/pages/daily_mission_page.dart';
import 'package:mintrix/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_event.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart'; // ✅ Add ProfileBloc
import 'package:mintrix/features/profile/presentation/bloc/profile_state.dart'; // ✅ Add ProfileState
import 'package:mintrix/features/profile/presentation/bloc/profile_event.dart'; // ✅ Add ProfileEvent
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    // ✅ Fetch profile saat HomePage pertama kali dibuka
    _fetchAndUpdateProfile();
    // ✅ Load ProfileBloc untuk mendapatkan streak data
    context.read<ProfileBloc>().add(LoadProfile());
  }

  // ✅ Fetch profile dari API dan update AuthBloc
  Future<void> _fetchAndUpdateProfile() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.profile, // Sesuaikan dengan endpoint Anda
        requiresAuth: true,
      );

      if (response['data'] != null) {
        final userData = response['data'];

        // ✅ Update AuthBloc dengan data terbaru dari database
        if (mounted) {
          context.read<AuthBloc>().add(
            UpdateProfileEvent(
              userId: userData['_id'].toString(),
              username: userData['nama'] ?? 'User',
              photoUrl: userData['foto'],
            ),
          );

          // ✅ Refresh ProfileBloc juga untuk update streak
          context.read<ProfileBloc>().add(RefreshProfile());
        }

        print(
          '✅ Profile updated: ${userData['nama']}, Photo: ${userData['foto']}',
        );
      }
    } catch (e) {
      print('❌ Failed to fetch profile: $e');
      // Tidak perlu show error, karena ini background fetch
    }
  }

  // Helper function untuk memotong username
  String _truncateUsername(String username) {
    if (username.length > 10) {
      return '${username.substring(0, 10)}...';
    }
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FF),
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String username = 'User';
            String? photoUrl;

            if (authState is AuthAuthenticated) {
              username = authState.username;
              photoUrl = authState.photoUrl;
            }

            return RefreshIndicator(
              onRefresh: _fetchAndUpdateProfile, // ✅ Pull to refresh
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, username, photoUrl),
                    const SizedBox(height: 30),
                    _buildLargeCard(),
                    const SizedBox(height: 24),
                    _buildMenuGrid(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String username, String? photoUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
              ? NetworkImage(photoUrl)
              : const AssetImage('assets/images/dino_get_started.png')
                    as ImageProvider,
          backgroundColor: Colors.grey[300],
          onBackgroundImageError: (exception, stackTrace) {
            print('❌ Error loading image: $exception');
          },
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ayo bermain",
              style: secondaryTextStyle.copyWith(fontSize: 12),
            ),
            Text(
              _truncateUsername(username),
              style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),
            ),
          ],
        ),
        const Spacer(),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            int streakCount = 0;
            bool streakActive = false;

            if (profileState is ProfileLoaded) {
              streakCount = profileState.streakCount;
              streakActive = profileState.streakActive;
            }

            return Row(
              children: [
                Image.asset(
                  "assets/icons/fire.png",
                  height: 36,
                  // 🔥 Warna berubah jika streak tidak aktif
                  color: streakActive && streakCount > 0 ? null : Colors.grey,
                  colorBlendMode: streakActive && streakCount > 0
                      ? BlendMode.dst
                      : BlendMode.srcIn,
                ),
                const SizedBox(width: 4),
                Text(
                  "$streakCount",
                  style: bluePrimaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(width: 16),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyMissionPage()),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: bluePrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Misi Harian",
            style: whiteTextStyle.copyWith(fontWeight: semiBold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LeaderboardPage()),
        );
      },
      child: const CustomHomeCardLarge(
        title: 'Liga Emas',
        subTitle: 'Posisi 1',
        description:
            'Pertahankan posisimu dengan menyelesaikan misi harian dan mengisi catatan harian',
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                context.read<NavigationBloc>().add(UpdateIndex(1));
              },
              child: CustomHomeCardSmall(
                images:
                    "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846593/character5_v8uvxf.png",
                title: "Permainan",
                subTitle: "Ayo bermain dan belajar",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DailyNotesPage(),
                  ),
                );
              },
              child: const CustomHomeCardSmall(
                images:
                    "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846600/character12_bpnhx5.png",
                title: "Catatan harian",
                subTitle: "Ceritakan kegiatanmu hari ini",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                context.read<NavigationBloc>().add(UpdateIndex(2));
              },
              child: CustomHomeCardSmall(
                images:
                    "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762848439/character10_hrs1i5.png",
                title: "Assisten",
                subTitle: "Mulai mengembangkan dirimu dengan bantuan Dino",
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<NavigationBloc>().add(UpdateIndex(4));
              },
              child: const CustomHomeCardSmall(
                images:
                    "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846596/character8_uhbkoc.png",
                title: "Toko",
                subTitle: "Tingkatkan performa dengan membeli item",
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }
}
