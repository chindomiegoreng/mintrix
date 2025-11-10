import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/duration_option_model.dart';
import 'package:mintrix/core/models/personalization_response_model.dart'; // ✅ Pastikan import ini ada
import 'package:shared_preferences/shared_preferences.dart';
import 'personalization_event.dart';
import 'personalization_state.dart';

class PersonalizationBloc
    extends Bloc<PersonalizationEvent, PersonalizationState> {
  final ApiClient _apiClient;
  DurationOptionModel? _savedDuration;

  // ✅ Default options jika API tidak tersedia
  static final List<DurationOptionModel> _defaultDurationOptions = [
    DurationOptionModel(
      id: '1',
      duration: 5,
      title: '5 Menit',
      subtitle: 'Santai tapi asik',
    ),
    DurationOptionModel(
      id: '2',
      duration: 10,
      title: '10 Menit',
      subtitle: 'Tambah kece',
    ),
    DurationOptionModel(
      id: '3',
      duration: 15,
      title: '15 Menit',
      subtitle: 'Jagoan',
    ),
    DurationOptionModel(
      id: '4',
      duration: 30,
      title: '30 Menit',
      subtitle: 'Super duper keren',
    ),
  ];

  PersonalizationBloc({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(),
      super(PersonalizationInitial()) {
    on<LoadDurationOptions>(_onLoadDurationOptions);
    on<UpdatePersonalizationStep>(_onUpdateStep);
    on<UpdateLearningDuration>(_onUpdateDuration);
    on<CompleteFirstStage>(_onCompleteFirstStage);
    on<SkipSecondStage>(_onSkipSecondStage);
    on<UpdateWeaknesses>(_onUpdateWeaknesses);
    on<UpdateStrengths>(_onUpdateStrengths);
    on<UpdateStory>(_onUpdateStory);
    on<CompletePersonalization>(_onCompletePersonalization);
  }

  // ✅ Load duration options (dari API atau default)
  void _onLoadDurationOptions(
    LoadDurationOptions event,
    Emitter<PersonalizationState> emit,
  ) async {
    try {
      emit(
        PersonalizationStage1(
          currentStep: 2,
          durationOptions: _defaultDurationOptions,
        ),
      );
    } catch (e) {
      print('⚠️ Error loading duration options, using defaults: $e');
      emit(
        PersonalizationStage1(
          currentStep: 2,
          durationOptions: _defaultDurationOptions,
        ),
      );
    }
  }

  void _onUpdateStep(
    UpdatePersonalizationStep event,
    Emitter<PersonalizationState> emit,
  ) {
    if (state is PersonalizationStage1) {
      final current = state as PersonalizationStage1;
      emit(current.copyWith(currentStep: event.step));
    } else if (state is PersonalizationStage2) {
      final current = state as PersonalizationStage2;
      emit(current.copyWith(currentStep: event.step));
    }
  }

  void _onUpdateDuration(
    UpdateLearningDuration event,
    Emitter<PersonalizationState> emit,
  ) {
    if (state is PersonalizationStage1) {
      final current = state as PersonalizationStage1;
      emit(current.copyWith(selectedDuration: event.duration));
    } else {
      emit(
        PersonalizationStage1(
          currentStep: 2,
          selectedDuration: event.duration,
          durationOptions: _defaultDurationOptions,
        ),
      );
    }
    _savedDuration = event.duration;
  }

  void _onCompleteFirstStage(
    CompleteFirstStage event,
    Emitter<PersonalizationState> emit,
  ) {
    DurationOptionModel? duration;
    if (state is PersonalizationStage1) {
      duration = (state as PersonalizationStage1).selectedDuration;
      _savedDuration = duration;
    }
    emit(PersonalizationStage1Complete(selectedDuration: duration));
  }

  void _onSkipSecondStage(
    SkipSecondStage event,
    Emitter<PersonalizationState> emit,
  ) async {
    await _saveToPreferences(_savedDuration, [], [], '');
    emit(PersonalizationCompleted());
  }

  void _onUpdateWeaknesses(
    UpdateWeaknesses event,
    Emitter<PersonalizationState> emit,
  ) {
    if (state is PersonalizationStage2) {
      final current = state as PersonalizationStage2;
      emit(current.copyWith(selectedWeaknesses: event.weaknesses));
    } else {
      emit(
        PersonalizationStage2(
          currentStep: 1,
          selectedWeaknesses: event.weaknesses,
        ),
      );
    }
  }

  void _onUpdateStrengths(
    UpdateStrengths event,
    Emitter<PersonalizationState> emit,
  ) {
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

  void _onCompletePersonalization(
    CompletePersonalization event,
    Emitter<PersonalizationState> emit,
  ) async {
    try {
      final currentState = state;
      emit(PersonalizationLoading());

      List<String> weaknesses = [];
      List<String> strengths = [];
      String story = '';

      if (currentState is PersonalizationStage2) {
        weaknesses = currentState.selectedWeaknesses;
        strengths = currentState.selectedStrengths;
        story = currentState.story;
      }

      if (_savedDuration == null || _savedDuration!.title.isEmpty) {
        emit(PersonalizationError('Waktu belajar harus dipilih'));
        return;
      }

      if (weaknesses.isEmpty) {
        emit(PersonalizationError('Pilih minimal 1 kekurangan'));
        return;
      }

      if (strengths.isEmpty) {
        emit(PersonalizationError('Pilih minimal 1 kelebihan'));
        return;
      }

      if (story.isEmpty || story.length < 10) {
        emit(PersonalizationError('Cerita singkat minimal 10 karakter'));
        return;
      }

      final requestBody = {
        'waktuBelajar': _savedDuration!.title,
        'kekurangan': weaknesses,
        'kelebihan': strengths,
        'ceritaSingkat': story,
      };

      print('📤 Sending personalization data: $requestBody');

      final response = await _apiClient.post(
        ApiEndpoints.personalization,
        body: requestBody,
        requiresAuth: true,
      );

      print('✅ Personalization response: $response');

      final personalizationResponse = PersonalizationResponseModel.fromJson(
        response,
      );

      await _saveToPreferences(_savedDuration, weaknesses, strengths, story);

      emit(PersonalizationCompleted());

      print('🎉 Personalization berhasil: ${personalizationResponse.message}');
    } catch (e) {
      print('❌ Personalization error: $e');
      emit(PersonalizationError(_parseError(e.toString())));
    }
  }

  String _parseError(String error) {
    if (error.contains('Network error')) {
      return 'Koneksi internet bermasalah';
    } else if (error.contains('Token expired')) {
      return 'Sesi berakhir, silakan login kembali';
    } else if (error.contains('Unauthorized')) {
      return 'Unauthorized. Silakan login kembali';
    } else if (error.contains('Exception:')) {
      return error.replaceAll('Exception:', '').trim();
    }
    return error;
  }

  Future<void> _saveToPreferences(
    DurationOptionModel? duration,
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

      if (weaknesses != null && weaknesses.isNotEmpty) {
        await prefs.setStringList('weaknesses', weaknesses);
      }

      if (strengths != null && strengths.isNotEmpty) {
        await prefs.setStringList('strengths', strengths);
      }

      if (story.isNotEmpty) {
        await prefs.setString('story', story);
      }

      print('✅ Personalization saved to local storage');
    } catch (e) {
      print('❌ Error saving to preferences: $e');
    }
  }
}
