part of 'daily_notes_bloc.dart';

sealed class DailyNotesState extends Equatable {
  const DailyNotesState();
  
  @override
  List<Object> get props => [];
}

final class DailyNotesInitial extends DailyNotesState {}
