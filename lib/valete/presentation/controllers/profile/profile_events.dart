import 'package:equatable/equatable.dart';
import 'package:valet_app/valete/data/models/update_valet_model.dart';

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
class UpdateValetEvent extends ProfileEvents {
  final UpdateValetModel model;
  UpdateValetEvent(this.model);

  @override
  List<Object?> get props => [model];
}
class ChangeStatusEvent extends ProfileEvents {
  final Status status;
  ChangeStatusEvent(this.status);

  @override
  List<Object?> get props =>[status];
}

class InitProfileEvent extends ProfileEvents {
  final UpdateValetModel model;
  InitProfileEvent(this.model);

  @override
  List<Object?> get props =>[model];
}

