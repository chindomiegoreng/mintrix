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

  const LeaderboardLoaded({
    required this.users,
    this.myRank,
  });

  @override
  List<Object?> get props => [users, myRank];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object> get props => [message];
}