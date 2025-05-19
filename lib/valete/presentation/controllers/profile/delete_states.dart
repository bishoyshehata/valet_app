import '../../../../core/utils/enums.dart';

class DeleteState {
  final bool? deletedata;
  final RequestState? deleteState;
  final String? deleteErrorMessage;

  DeleteState({
    this.deleteState =RequestState.loading,
    this.deleteErrorMessage = '',
    this.deletedata,
  });


  DeleteState copyWith({
     bool? deletedata,
    RequestState? deleteState,
    String? deleteErrorMessage,
  }) {
    return DeleteState(
      deletedata: deletedata ?? this.deletedata,
      deleteState: deleteState ?? this.deleteState,
      deleteErrorMessage: deleteErrorMessage ?? this.deleteErrorMessage,
    );
  }
}
