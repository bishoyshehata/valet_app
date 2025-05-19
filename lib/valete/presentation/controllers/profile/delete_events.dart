import 'package:equatable/equatable.dart';

abstract class DeleteEvent extends Equatable {}

class DeleteValetEvent extends DeleteEvent{
  final int valetId;
  DeleteValetEvent(this.valetId);

  @override
  List<Object?> get props => [valetId];

}



