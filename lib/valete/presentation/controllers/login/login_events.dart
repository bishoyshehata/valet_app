
import 'package:equatable/equatable.dart';

abstract class LoginEvents extends Equatable{
  const LoginEvents();

  @override
  List<Object?> get props => throw UnimplementedError();

}
class CompletePhoneChanged extends LoginEvents {
  final String phoneNumber;
  final String countryCode;
  const CompletePhoneChanged({required this.phoneNumber, required this.countryCode});

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}


class PasswordChanged extends LoginEvents {
  final String password;
  const PasswordChanged(this.password);
}

class LoginSubmitted extends LoginEvents {
  final String countryCode;

  LoginSubmitted({required this.countryCode});

  @override
  List<Object?> get props => [countryCode];
}

class TogglePasswordVisibility extends LoginEvents {}

class ResetLoginStatus extends LoginEvents {}
