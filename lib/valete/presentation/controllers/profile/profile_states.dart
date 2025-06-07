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


  ProfileState({
    this.deleteState =RequestState.loading,
    this.deleteErrorMessage = '',
    this.deletedata,
    this.termsState =RequestState.loading,
    this.logOutState =LogOutState.initial,
    this.settingErrorMessage ='',
    this.settingsData,
    this.settingsState = RequestState.loading,
    this.settingsStatusCode=0,
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
    );
  }
}
