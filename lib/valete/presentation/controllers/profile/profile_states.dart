import '../../../../core/utils/enums.dart';

class ProfileState {
  final bool? deletedata;
  final RequestState? deleteState;
  final String? deleteErrorMessage;
  final RequestState? termsState;
  final LogOutState? logOutState;


  ProfileState({
    this.deleteState =RequestState.loading,
    this.deleteErrorMessage = '',
    this.deletedata,
    this.termsState =RequestState.loading,
    this.logOutState =LogOutState.initial,

  });


  ProfileState copyWith({
     bool? deletedata,
    RequestState? deleteState,
    String? deleteErrorMessage,
    RequestState? termsState,
    LogOutState? logOutState,

  }) {
    return ProfileState(
      deletedata: deletedata ?? this.deletedata,
      deleteState: deleteState ?? this.deleteState,
      deleteErrorMessage: deleteErrorMessage ?? this.deleteErrorMessage,
      termsState: termsState ?? this.termsState,
      logOutState: logOutState ?? this.logOutState,
    );
  }
}
