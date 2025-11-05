part of 'daily_notes_bloc.dart';

abstract class DailyNotesEvent extends Equatable {
  const DailyNotesEvent();

  @override
  List<Object> get props => [];
}

class LoadDailyNotes extends DailyNotesEvent {}

class AddDailyNote extends DailyNotesEvent {
  final Note note;
  const AddDailyNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateDailyNote extends DailyNotesEvent {
  final Note note;
  const UpdateDailyNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteDailyNote extends DailyNotesEvent {
  final String id;
  const DeleteDailyNote(this.id);

  @override
  List<Object> get props => [id];
}
