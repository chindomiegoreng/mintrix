import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  final int index;
  const NavigationState(this.index);

  @override
  List<Object> get props => [index];
}

class NavigationInitial extends NavigationState {
  const NavigationInitial() : super(0);
}

class NavigationUpdated extends NavigationState {
  const NavigationUpdated(int index) : super(index);
}