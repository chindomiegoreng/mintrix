import 'package:mintrix/core/models/duration_option_model.dart';

abstract class PersonalizationEvent {}

class LoadDurationOptions
    extends PersonalizationEvent {} // ✅ Event untuk load options

class UpdatePersonalizationStep extends PersonalizationEvent {
  final int step;
  UpdatePersonalizationStep(this.step);
}

class UpdateLearningDuration extends PersonalizationEvent {
  final DurationOptionModel duration; // ✅ Changed type
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