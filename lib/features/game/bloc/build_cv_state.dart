part of 'build_cv_bloc.dart';

abstract class BuildCVState {}

class CVInitial extends BuildCVState {}

class CVInProgress extends BuildCVState {
  final int currentStep;

  CVInProgress(this.currentStep);
}

class CVCompleted extends BuildCVState {}