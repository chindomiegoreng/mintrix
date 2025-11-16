import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/note_model.dart';

part 'daily_notes_event.dart';
part 'daily_notes_state.dart';

class DailyNotesBloc extends Bloc<DailyNotesEvent, DailyNotesState> {
  final ApiClient _apiClient;

  DailyNotesBloc({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(),
        super(DailyNotesInitial()) {
    on<LoadDailyNotes>(_onLoadDailyNotes);
    on<AddDailyNote>(_onAddDailyNote);
    on<UpdateDailyNote>(_onUpdateDailyNote);
    on<DeleteDailyNote>(_onDeleteDailyNote);
  }

  // ✅ Load notes dari API
  Future<void> _onLoadDailyNotes(
    LoadDailyNotes event,
    Emitter<DailyNotesState> emit,
  ) async {
    try {
      emit(DailyNotesLoading());

      final response = await _apiClient.get(
        ApiEndpoints.dailyNotes,
        requiresAuth: true,
      );

      final List<dynamic> notesData = response['data'] ?? [];
      final notes = notesData.map((json) => Note.fromJson(json)).toList();

      // ✅ Sort by createdAt descending (terbaru di atas)
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(DailyNotesLoaded(notes));
      print('✅ Loaded ${notes.length} notes');
    } catch (e) {
      emit(DailyNotesError('Gagal memuat catatan: ${e.toString()}'));
      print('❌ Error loading notes: $e');
    }
  }

  // ✅ Add note ke API
  Future<void> _onAddDailyNote(
    AddDailyNote event,
    Emitter<DailyNotesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! DailyNotesLoaded) return;

      emit(DailyNotesLoading());

      final response = await _apiClient.post(
        ApiEndpoints.dailyNotes,
        body: event.note.toJson(),
        requiresAuth: true,
      );

      final newNote = Note.fromJson(response['data']);
      
      // ✅ Insert note baru di awal list
      final updatedNotes = [newNote, ...currentState.notes];

      emit(DailyNotesLoaded(updatedNotes));
      print('✅ Note added: ${newNote.id}');
      print('📝 Message: ${response['message']}');
    } catch (e) {
      final currentState = state;
      if (currentState is DailyNotesLoaded) {
        emit(DailyNotesLoaded(currentState.notes));
      }
      emit(DailyNotesError('Gagal menambah catatan: ${e.toString()}'));
      print('❌ Error adding note: $e');
    }
  }

  // ✅ Update note di API
  Future<void> _onUpdateDailyNote(
    UpdateDailyNote event,
    Emitter<DailyNotesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! DailyNotesLoaded) return;

      emit(DailyNotesLoading());

      final response = await _apiClient.put(
        ApiEndpoints.dailyNoteById(event.note.id),
        body: event.note.toJson(),
        requiresAuth: true,
      );

      final updatedNote = Note.fromJson(response['data']);

      // ✅ Update note di list
      final updatedNotes = currentState.notes.map((note) {
        return note.id == updatedNote.id ? updatedNote : note;
      }).toList();

      emit(DailyNotesLoaded(updatedNotes));
      print('✅ Note updated: ${updatedNote.id}');
    } catch (e) {
      final currentState = state;
      if (currentState is DailyNotesLoaded) {
        emit(DailyNotesLoaded(currentState.notes));
      }
      emit(DailyNotesError('Gagal mengupdate catatan: ${e.toString()}'));
      print('❌ Error updating note: $e');
    }
  }

  // ✅ Delete note dari API
  Future<void> _onDeleteDailyNote(
    DeleteDailyNote event,
    Emitter<DailyNotesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! DailyNotesLoaded) return;

      emit(DailyNotesLoading());

      // ✅ Gunakan method DELETE
      await _apiClient.delete(
        ApiEndpoints.dailyNoteById(event.id),
        requiresAuth: true,
      );

      // ✅ Remove note dari list
      final updatedNotes = currentState.notes
          .where((note) => note.id != event.id)
          .toList();

      emit(DailyNotesLoaded(updatedNotes));
      print('✅ Note deleted: ${event.id}');
    } catch (e) {
      final currentState = state;
      if (currentState is DailyNotesLoaded) {
        emit(DailyNotesLoaded(currentState.notes));
      }
      emit(DailyNotesError('Gagal menghapus catatan: ${e.toString()}'));
      print('❌ Error deleting note: $e');
    }
  }

  @override
  Future<void> close() {
    _apiClient.dispose();
    return super.close();
  }
}