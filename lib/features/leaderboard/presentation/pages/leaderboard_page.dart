import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintrix/features/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:mintrix/features/leaderboard/cubit/leaderboard_state.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/leaderboard_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeaderboardCubit()..loadLeaderboard(), // ✅ Auto load
      child: const _LeaderboardView(),
    );
  }
}

class _LeaderboardView extends StatelessWidget {
  const _LeaderboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background & Content
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/leaderboard_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 64),
                _buildHeader(),
                const SizedBox(height: 12),
                _buildBadges(),

                // ✅ Podium animasi otomatis dari Cubit
                BlocBuilder<LeaderboardCubit, LeaderboardState>(
                  builder: (context, state) {
                    if (state is LeaderboardLoaded && state.users.isNotEmpty) {
                      final topThree = state.users.take(3).toList();
                      return LeaderboardAnimation(topUsers: topThree);
                    }
                    return const SizedBox(height: 310);
                  },
                ),

                const SizedBox(height: 200),
              ],
            ),
          ),

          // ✅ Draggable Bottom Sheet (4 ke bawah)
          _buildDraggableSheet(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
      builder: (context, state) {
        // ✅ Ambil daysLeft dari state
        int daysLeft = 0;
        if (state is LeaderboardLoaded) {
          daysLeft = state.daysLeft;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Liga Mintrix",
                  style: primaryTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "5 besar akan melaju ke babak selanjutnya",
                  style: primaryTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: bluePrimaryColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "$daysLeft", // ✅ Dynamic days left
                    style: bluePrimaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    " Hari",
                    style: bluePrimaryTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget _buildBadges() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Image.asset("assets/images/leaderboard_badges.png")
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBadges() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762850967/character1_lamw4v.png',
            width: 450,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.70,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(color: thirdColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: thirdColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
                  builder: (context, state) {
                    if (state is LeaderboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LeaderboardError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: primaryTextStyle.copyWith(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: medium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<LeaderboardCubit>()
                                    .loadLeaderboard();
                              },
                              child: Text(
                                'Coba Lagi',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is LeaderboardLoaded) {
                      // ✅ Limit to maximum 30 users total (3 in podium + 27 in list)
                      final maxUsers = 30;
                      final allUsers = state.users.take(maxUsers).toList();

                      if (allUsers.length <= 3) {
                        return const Center(
                          child: Text('Belum ada data lanjutan'),
                        );
                      }

                      final remainingUsers = allUsers.skip(3).toList();

                      return RefreshIndicator(
                        onRefresh: () => context
                            .read<LeaderboardCubit>()
                            .refreshLeaderboard(),
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          physics: const ClampingScrollPhysics(),
                          itemCount:
                              remainingUsers.length + 1, // +1 for "Zona Aman"
                          itemBuilder: (context, index) {
                            // ✅ Zona Aman after rank 5 (index 2 in remainingUsers)
                            if (index == 2 && remainingUsers.length > 2) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/leaderboard_arrow.svg",
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Zona aman",
                                      style: primaryTextStyle.copyWith(
                                        color: greenColor,
                                        fontSize: 16,
                                        fontWeight: bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SvgPicture.asset(
                                      "assets/icons/leaderboard_arrow.svg",
                                    ),
                                  ],
                                ),
                              );
                            }

                            // ✅ Adjust index to account for "Zona Aman" separator
                            final userIndex = index > 2 ? index - 1 : index;

                            // ✅ Safety check
                            if (userIndex >= remainingUsers.length) {
                              return const SizedBox.shrink();
                            }

                            final user = remainingUsers[userIndex];
                            final rank = userIndex + 4;

                            return _buildLeaderboardItem(
                              rank: rank,
                              name: user.nama,
                              xp: user.xp,
                              image: user.foto,
                              isHighlight: false,
                            );
                          },
                        ),
                      );
                    }

                    // ✅ Default return statement
                    return const Center(child: Text('Tidak ada data'));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required int xp,
    String? image,
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight
            ? bluePrimaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              "$rank",
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: bold,
                color: secondaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: secondaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: image != null && image.isNotEmpty
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.person,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Text(
              name,
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // XP Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: greenColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/icons/leaderboard_xp.svg",
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "$xp",
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
