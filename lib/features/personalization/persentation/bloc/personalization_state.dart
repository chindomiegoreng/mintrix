import 'package:mintrix/widgets/personalization_long_learning_button.dart';

abstract class PersonalizationState {}

class PersonalizationInitial extends PersonalizationState {}

class PersonalizationStage1 extends PersonalizationState {
  final int currentStep;
  final DurationOption? selectedDuration;

  PersonalizationStage1({
    required this.currentStep,
    this.selectedDuration,
  });

  PersonalizationStage1 copyWith({
    int? currentStep,
    DurationOption? selectedDuration,
  }) {
    return PersonalizationStage1(
      currentStep: currentStep ?? this.currentStep,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }
}

class PersonalizationStage1Complete extends PersonalizationState {
  final DurationOption? selectedDuration;

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