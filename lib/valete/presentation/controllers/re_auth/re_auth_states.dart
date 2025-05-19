
import '../../../../core/utils/enums.dart';

class ReAuthState {
  final ReAuthStatus status;
  final String? errorMessage;

  ReAuthState({this.status = ReAuthStatus.idle, this.errorMessage});

  ReAuthState copyWith({ReAuthStatus? status, String? errorMessage}) {
    return ReAuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}