import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_state.dart';

class GameHeaderWidget extends StatelessWidget {
  const GameHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading) {
          return _buildLoadingHeader();
        }

        if (profileState is ProfileLoaded) {
          return _buildLoadedHeader(profileState);
        }

        return _buildDefaultHeader();
      },
    );
  }

  Widget _buildLoadingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          _buildStreakSection(0, false),
          _buildGemsSection(0),
          _buildXPSection(0),
        ],
      ),
    );
  }

  Widget _buildLoadedHeader(ProfileLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProfileAvatar(state.foto),
          _buildStreakSection(state.streakCount, state.streakActive),
          _buildGemsSection(state.point),
          _buildXPSection(state.xp),
        ],
      ),
    );
  }

  Widget _buildDefaultHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          _buildStreakSection(0, false),
          _buildGemsSection(0),
          _buildXPSection(0),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String? foto) {
    if (foto != null && foto.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: CachedNetworkImageProvider(foto),
        backgroundColor: Colors.grey[200],
        onBackgroundImageError: (_, __) {},
        child: foto.isEmpty
            ? const Icon(Icons.person, size: 22, color: Colors.grey)
            : null,
      );
    }

    return const CircleAvatar(
      radius: 22,
      backgroundImage: AssetImage('assets/images/profile.png'),
      backgroundColor: Colors.grey,
    );
  }

  Widget _buildStreakSection(int streakCount, bool isActive) {
    return Row(
      children: [
        // API fire icon - berubah warna berdasarkan streak aktif
        Image.asset(
          "assets/icons/fire.png",
          height: 36,
          color: isActive && streakCount > 0 
              ? null // Gunakan warna asli (orange/merah)
              : Colors.grey, // Abu-abu jika tidak aktif
          colorBlendMode: isActive && streakCount > 0 
              ? BlendMode.dst 
              : BlendMode.srcIn,
        ),
        const SizedBox(width: 4),
        Text(
          "$streakCount",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive && streakCount > 0 
                ? Colors.black87 
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildGemsSection(int gems) {
    return Row(
      children: [
        Image.asset("assets/icons/icon_diamond.png", height: 36),
        const SizedBox(width: 4),
        Text(
          "$gems",
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildXPSection(int xp) {
    return Text(
      "XP $xp",
      style: const TextStyle(
        color: Colors.green,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}