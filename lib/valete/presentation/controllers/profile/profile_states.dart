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
  final Status? initialStatus;
  final Status? selectedStatus;

  bool get isChanged =>
      initialStatus != null &&
          selectedStatus != null &&
          initialStatus != selectedStatus;

  ProfileState({
    this.deleteState =RequestState.loading,
    this.deleteErrorMessage = '',
    this.deletedata,
    this.termsState =RequestState.loading,
    this.logOutState =LogOutState.initial,
    this.settingErrorMessage ='',
    this.settingsData,
    this.isWhatsAppWorking,
    this.settingsState = RequestState.loading,
    this.settingsStatusCode=0,
    this.initialStatus,
    this.selectedStatus,
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
    Status? initialStatus,
    Status? selectedStatus,

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
      initialStatus: initialStatus ?? this.initialStatus,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}
