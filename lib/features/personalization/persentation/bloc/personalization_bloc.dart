import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/widgets/personalization_long_learning_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'personalization_event.dart';
import 'personalization_state.dart';

class PersonalizationBloc extends Bloc<PersonalizationEvent, PersonalizationState> {
  PersonalizationBloc() : super(PersonalizationInitial()) {
    on<UpdatePersonalizationStep>(_onUpdateStep);
    on<UpdateLearningDuration>(_onUpdateDuration);
    on<CompleteFirstStage>(_onCompleteFirstStage);
    on<SkipSecondStage>(_onSkipSecondStage);
    on<UpdateWeaknesses>(_onUpdateWeaknesses);
    on<UpdateStrengths>(_onUpdateStrengths);
    on<UpdateStory>(_onUpdateStory);
    on<CompletePersonalization>(_onComplete);
  }

  void _onUpdateStep(UpdatePersonalizationStep event, Emitter<PersonalizationState> emit) {
    if (state is PersonalizationStage1) {
      final current = state as PersonalizationStage1;
      emit(current.copyWith(currentStep: event.step));
    } else if (state is PersonalizationStage2) {
      final current = state as PersonalizationStage2;
      emit(current.copyWith(currentStep: event.step));
    } else if (state is PersonalizationInitial) {
      emit(PersonalizationStage1(currentStep: event.step));
    }
  }

  void _onUpdateDuration(UpdateLearningDuration event, Emitter<PersonalizationState> emit) {
    if (state is PersonalizationStage1) {
      final current = state as PersonalizationStage1;
      emit(current.copyWith(selectedDuration: event.duration));
    }
  }

  void _onCompleteFirstStage(CompleteFirstStage event, Emitter<PersonalizationState> emit) {
    DurationOption? duration;
    if (state is PersonalizationStage1) {
      duration = (state as PersonalizationStage1).selectedDuration;
    }
    emit(PersonalizationStage1Complete(selectedDuration: duration));
  }

  void _onSkipSecondStage(SkipSecondStage event, Emitter<PersonalizationState> emit) async {
    await _saveToPreferences(null, null, null, '');
    emit(PersonalizationCompleted());
  }

  void _onUpdateWeaknesses(UpdateWeaknesses event, Emitter<PersonalizationState> emit) {
    if (state is PersonalizationStage2) {
      final current = state as PersonalizationStage2;
      emit(current.copyWith(selectedWeaknesses: event.weaknesses));
    }
  }

  void _onUpdateStrengths(UpdateStrengths event, Emitter<PersonalizationState> emit) {
    if (state is PersonalizationStage2) {
      final current = state as PersonalizationStage2;
      emit(current.copyWith(selectedStrengths: event.strengths));
    }
  }

  void _onUpdateStory(UpdateStory event, Emitter<PersonalizationState> emit) {
    if (state is PersonalizationStage2) {
      final current = state as PersonalizationStage2;
      emit(current.copyWith(story: event.story));
    }
  }

  void _onComplete(CompletePersonalization event, Emitter<PersonalizationState> emit) async {
    DurationOption? duration;
    List<String>? weaknesses;
    List<String>? strengths;
    String story = '';

    if (state is PersonalizationStage2) {
      final current = state as PersonalizationStage2;
      weaknesses = current.selectedWeaknesses;
      strengths = current.selectedStrengths;
      story = current.story;
    }

    await _saveToPreferences(duration, weaknesses, strengths, story);
    emit(PersonalizationCompleted());
  }

  Future<void> _saveToPreferences(
    DurationOption? duration,
    List<String>? weaknesses,
    List<String>? strengths,
    String story,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasCompletedPersonalization', true);

      if (duration != null) {
        await prefs.setInt('learningDuration', duration.duration);
        await prefs.setString('learningDurationTitle', duration.title);
      }
      if (weaknesses != null) {
        await prefs.setStringList('weaknesses', weaknesses);
      }
      if (strengths != null) {
        await prefs.setStringList('strengths', strengths);
      }
      if (story.isNotEmpty) {
        await prefs.setString('story', story);
      }
    } catch (e) {
      print('Error saving personalization: $e');
    }
  }
}