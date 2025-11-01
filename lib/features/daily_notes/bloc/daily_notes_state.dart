part of 'daily_notes_bloc.dart';

abstract class DailyNotesState extends Equatable {
  const DailyNotesState();

  @override
  List<Object> get props => [];
}

class DailyNotesInitial extends DailyNotesState {}

class DailyNotesLoading extends DailyNotesState {}

class DailyNotesLoaded extends DailyNotesState {
  final List<Note> notes;
  const DailyNotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class DailyNotesError extends DailyNotesState {
  final String message;
  const DailyNotesError(this.message);

  @override
  List<Object> get props => [message];
}
