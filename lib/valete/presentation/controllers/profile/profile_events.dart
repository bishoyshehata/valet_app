import 'package:equatable/equatable.dart';

import '../../../../core/utils/enums.dart';

abstract class ProfileEvents extends Equatable {}

class DeleteValetEvent extends ProfileEvents{
  final int valetId;
  DeleteValetEvent(this.valetId);

  @override
  List<Object?> get props => [valetId];

}
class LoadTermsEvent extends ProfileEvents {
  @override
  List<Object?> get props => [];
}
class TermsLoadedEvent extends ProfileEvents {
  @override
  List<Object?> get props => [];
}
class LogoutEvent extends ProfileEvents {
  @override
  List<Object?> get props => [];
}
class GetSettingsEvent extends ProfileEvents {
  @override
  List<Object?> get props => [];
}

class ChangeStatusEvent extends ProfileEvents {
  final Status selectedStatus;
  ChangeStatusEvent(this.selectedStatus);

  @override
  List<Object?> get props => [selectedStatus];
}

class SaveStatusEvent extends ProfileEvents {
  @override
  List<Object?> get props => [];
}




