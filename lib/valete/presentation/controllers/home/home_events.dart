import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {

}


class GetMyGaragesEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
class ChangeTabEvent extends HomeEvent {
  final int index;
   ChangeTabEvent(this.index);
  @override
  List<Object> get props => [index];
}

class ToggleExtraSlotsVisibilityEvent extends HomeEvent {
  final bool show;

  ToggleExtraSlotsVisibilityEvent(this.show);

  @override
  List<Object?> get props => [];
}

