import 'package:mintrix/core/models/duration_option_model.dart';

abstract class PersonalizationState {}

class PersonalizationInitial extends PersonalizationState {}

class PersonalizationLoading extends PersonalizationState {}

// ✅ State untuk load duration options dari API
class PersonalizationOptionsLoaded extends PersonalizationState {
  final List<DurationOptionModel> durationOptions;

  PersonalizationOptionsLoaded({required this.durationOptions});
}

class PersonalizationStage1 extends PersonalizationState {
  final int currentStep;
  final DurationOptionModel? selectedDuration; // ✅ Changed type
  final List<DurationOptionModel> durationOptions; // ✅ Add options list

  PersonalizationStage1({
    required this.currentStep,
    this.selectedDuration,
    this.durationOptions = const [],
  });

  PersonalizationStage1 copyWith({
    int? currentStep,
    DurationOptionModel? selectedDuration,
    List<DurationOptionModel>? durationOptions,
  }) {
    return PersonalizationStage1(
      currentStep: currentStep ?? this.currentStep,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      durationOptions: durationOptions ?? this.durationOptions,
    );
  }
}

class PersonalizationStage1Complete extends PersonalizationState {
  final DurationOptionModel? selectedDuration;

  PersonalizationStage1Complete({this.selectedDuration});
}

class PersonalizationStage2 extends PersonalizationState {
  final int currentStep;
  final List<String> selectedWeaknesses;
  final List<String> selectedStrengths;
  final String story;

  PersonalizationStage2({
    required this.currentStep,
    this.selectedWeaknesses = const [],
    this.selectedStrengths = const [],
    this.story = '',
  });

  PersonalizationStage2 copyWith({
    int? currentStep,
    List<String>? selectedWeaknesses,
    List<String>? selectedStrengths,
    String? story,
  }) {
    return PersonalizationStage2(
      currentStep: currentStep ?? this.currentStep,
      selectedWeaknesses: selectedWeaknesses ?? this.selectedWeaknesses,
      selectedStrengths: selectedStrengths ?? this.selectedStrengths,
      story: story ?? this.story,
    );
  }
}

class PersonalizationCompleted extends PersonalizationState {}

class PersonalizationError extends PersonalizationState {
  final String message;
  PersonalizationError(this.message);
}
