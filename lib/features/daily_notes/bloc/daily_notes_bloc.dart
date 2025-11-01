import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mintrix/features/daily_notes/models/note_model.dart';

part 'daily_notes_event.dart';
part 'daily_notes_state.dart';

class DailyNotesBloc extends Bloc<DailyNotesEvent, DailyNotesState> {
  final List<Note> _notes = [
    Note(id: '1', date: "08/09", content: "Tadi di kantin, teman-teman ngobrol seru sekali..."),
    Note(id: '2', date: "07/09", content: "Berhasil menyelesaikan progress kord lagu yang baru..."),
    Note(id: '3', date: "04/09", content: "Ada tugas kelompok lagi. Semoga saja nanti aku tidak hanya diam..."),
  ];

  DailyNotesBloc() : super(DailyNotesInitial()) {
    on<LoadDailyNotes>(_onLoadDailyNotes);
    on<AddDailyNote>(_onAddDailyNote);
    on<UpdateDailyNote>(_onUpdateDailyNote);
    on<DeleteDailyNote>(_onDeleteDailyNote);
  }

  Future<void> _onLoadDailyNotes(
    LoadDailyNotes event,
    Emitter<DailyNotesState> emit,
  ) async {
    emit(DailyNotesLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(DailyNotesLoaded(List.from(_notes)));
  }

  void _onAddDailyNote(AddDailyNote event, Emitter<DailyNotesState> emit) {
    final currentState = state;
    if (currentState is DailyNotesLoaded) {
      final updatedNotes = List<Note>.from(currentState.notes)..insert(0, event.note);
      emit(DailyNotesLoaded(updatedNotes));
    }
  }

  void _onUpdateDailyNote(UpdateDailyNote event, Emitter<DailyNotesState> emit) {
    final currentState = state;
    if (currentState is DailyNotesLoaded) {
      final index = currentState.notes.indexWhere((note) => note.id == event.note.id);
      if (index != -1) {
        final updatedNotes = List<Note>.from(currentState.notes);
        updatedNotes[index] = event.note;
        emit(DailyNotesLoaded(updatedNotes));
      }
    }
  }

  void _onDeleteDailyNote(DeleteDailyNote event, Emitter<DailyNotesState> emit) {
    final currentState = state;
    if (currentState is DailyNotesLoaded) {
      final updatedNotes = currentState.notes.where((note) => note.id != event.id).toList();
      emit(DailyNotesLoaded(updatedNotes));
    }
  }
}