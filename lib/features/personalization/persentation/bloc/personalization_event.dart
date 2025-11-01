
import 'package:mintrix/widgets/personalization_long_learning_button.dart';

abstract class PersonalizationEvent {}

class UpdatePersonalizationStep extends PersonalizationEvent {
  final int step;
  UpdatePersonalizationStep(this.step);
}

class UpdateLearningDuration extends PersonalizationEvent {
  final DurationOption duration;
  UpdateLearningDuration(this.duration);
}

class UpdateWeaknesses extends PersonalizationEvent {
  final List<String> weaknesses;
  UpdateWeaknesses(this.weaknesses);
}

class UpdateStrengths extends PersonalizationEvent {
  final List<String> strengths;
  UpdateStrengths(this.strengths);
}

class UpdateStory extends PersonalizationEvent {
  final String story;
  UpdateStory(this.story);
}

class CompleteFirstStage extends PersonalizationEvent {}

class SkipSecondStage extends PersonalizationEvent {}

class CompletePersonalization extends PersonalizationEvent {}