import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'daily_notes_event.dart';
part 'daily_notes_state.dart';

class DailyNotesBloc extends Bloc<DailyNotesEvent, DailyNotesState> {
  DailyNotesBloc() : super(DailyNotesInitial()) {
    on<DailyNotesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
