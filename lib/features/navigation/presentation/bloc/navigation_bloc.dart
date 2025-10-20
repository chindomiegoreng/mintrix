import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationInitial()) {
    on<UpdateIndex>(_onUpdateIndex);
  }

  void _onUpdateIndex(UpdateIndex event, Emitter<NavigationState> emit) {
    emit(NavigationUpdated(event.newIndex));
  }
}