import 'package:equatable/equatable.dart';
import 'package:mintrix/core/models/leaderboard_models.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardUser> users;
  final int? myRank; // Ranking user yang login (optional)
  final int daysLeft; // ✅ Hari tersisa dalam periode leaderboard

  const LeaderboardLoaded({
    required this.users,
    this.myRank,
    this.daysLeft = 0, // ✅ Default 0
  });

  @override
  List<Object?> get props => [users, myRank, daysLeft];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object> get props => [message];
}
