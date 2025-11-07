part of 'build_cv_bloc.dart';

abstract class BuildCVEvent {}

class UpdateCVStep extends BuildCVEvent {
  final int step;

  UpdateCVStep(this.step);
}

class CompleteCV extends BuildCVEvent {}