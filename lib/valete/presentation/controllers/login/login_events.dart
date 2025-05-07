
import 'package:equatable/equatable.dart';

abstract class LoginEvents extends Equatable{
  const LoginEvents();

  @override
  List<Object?> get props => throw UnimplementedError();

}

class PhoneChanged extends LoginEvents {
  final String phone;
  const PhoneChanged(this.phone);
}
class PasswordChanged extends LoginEvents {
  final String password;
  const PasswordChanged(this.password);
}

class LoginSubmitted extends LoginEvents {}

class TogglePasswordVisibility extends LoginEvents {}

class ResetLoginStatus extends LoginEvents {}
