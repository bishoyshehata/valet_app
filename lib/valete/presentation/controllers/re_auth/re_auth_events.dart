abstract class ReAuthEvent {}

class ShowPasswordPromptEvent extends ReAuthEvent {}

class RequestReAuth extends ReAuthEvent {
  final String password;
  RequestReAuth(this.password);
}

