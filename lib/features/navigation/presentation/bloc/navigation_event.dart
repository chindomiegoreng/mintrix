import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class UpdateIndex extends NavigationEvent {
  final int newIndex;

  const UpdateIndex(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}