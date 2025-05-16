import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}


class GetMyGaragesEvent extends HomeEvent {
  @override
  List<Object?> get props => [];

}
class GetMyOrdersEvent extends HomeEvent {
  final int newStatus;

  GetMyOrdersEvent(this.newStatus);

  @override

  List<Object?> get props => [newStatus];
}


class ChangeTabEvent extends HomeEvent {
  final int index;

   ChangeTabEvent(this.index);

  @override
  List<Object> get props => [index];
}
