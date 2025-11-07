import 'package:flutter_bloc/flutter_bloc.dart';
part 'build_cv_event.dart';
part 'build_cv_state.dart';

class BuildCVBloc extends Bloc<BuildCVEvent, BuildCVState> {
  BuildCVBloc() : super(CVInitial()) {
    on<UpdateCVStep>(_onUpdateCVStep);
    on<CompleteCV>(_onCompleteCV);
  }

  void _onUpdateCVStep(UpdateCVStep event, Emitter<BuildCVState> emit) {
    emit(CVInProgress(event.step));
  }

  void _onCompleteCV(CompleteCV event, Emitter<BuildCVState> emit) {
    emit(CVCompleted());
  }
}