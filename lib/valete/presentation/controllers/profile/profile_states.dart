import 'package:valet_app/valete/data/models/update_valet_model.dart';

import '../../../../core/utils/enums.dart';
import '../../../domain/entities/settings.dart';

class ProfileState {
  final bool? deletedata;
  final RequestState? deleteState;
  final String? deleteErrorMessage;
  final RequestState? termsState;
  final LogOutState? logOutState;
  final int? settingsStatusCode;
  final RequestState? settingsState;
  final Settings? settingsData;
  final String? settingErrorMessage;
  final bool? isWhatsAppWorking;
  final RequestStatess? updateValetState;
  final UpdateValetModel? updateValetData;
  final String? updateValetErrorMessage;
  final int? updateValetStatusCode;
  final Status? selectedStatus;
  final bool isStatusChanged;
  final UpdateValetModel? valetModel;

  ProfileState({
    this.deleteState =RequestState.loading,
    this.deleteErrorMessage = '',
    this.deletedata,
    this.termsState =RequestState.loading,
    this.logOutState =LogOutState.initial,
    this.settingErrorMessage ='',
    this.settingsData,
    this.isWhatsAppWorking =false,
    this.settingsState = RequestState.loading,
    this.settingsStatusCode=0,
    this.updateValetState = RequestStatess.initial,
    this.updateValetData,
    this.updateValetErrorMessage = '',
    this.updateValetStatusCode = 0,
    this.valetModel,
    this.selectedStatus = Status.Active,
    this.isStatusChanged = false,


  });


  ProfileState copyWith({
     bool? deletedata,
    RequestState? deleteState,
    String? deleteErrorMessage,
    RequestState? termsState,
    LogOutState? logOutState,
     int? settingsStatusCode,
     RequestState? settingsState,
     Settings? settingsData,
     String? settingErrorMessage,
     bool? isWhatsAppWorking,
    RequestStatess? updateValetState,
    UpdateValetModel? updateValetData,
    String? updateValetErrorMessage,
    int? updateValetStatusCode,
    UpdateValetModel? valetModel,
    Status? selectedStatus,
    bool? isStatusChanged,

  }) {
    return ProfileState(
      deletedata: deletedata ?? this.deletedata,
      deleteState: deleteState ?? this.deleteState,
      deleteErrorMessage: deleteErrorMessage ?? this.deleteErrorMessage,
      termsState: termsState ?? this.termsState,
      logOutState: logOutState ?? this.logOutState,
      settingsStatusCode: settingsStatusCode ?? this.settingsStatusCode,
      settingsState: settingsState ?? this.settingsState,
      settingsData: settingsData ?? this.settingsData,
      settingErrorMessage: settingErrorMessage ?? this.settingErrorMessage,
      isWhatsAppWorking: isWhatsAppWorking ?? this.isWhatsAppWorking,
      updateValetState: updateValetState ?? this.updateValetState,
      updateValetData: updateValetData ?? this.updateValetData,
      updateValetErrorMessage: updateValetErrorMessage,
      updateValetStatusCode: updateValetStatusCode ?? this.updateValetStatusCode,
        selectedStatus: selectedStatus,
        isStatusChanged: isStatusChanged ?? this.isStatusChanged,
      valetModel: valetModel ?? this.valetModel,

    );
  }
}
