import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/valet.dart';

class LoginStates extends Equatable {
  final String phone;
  final String password;
  final bool isPhoneValid;
  final bool isPasswordValid;
  final String? errorMessage;
  final Valet? data;
  final LoginStatus loginStatus;
  final bool isPasswordObscured;
  final bool hasInteractedWithPhone;
  final bool hasInteractedWithPassword;

  const LoginStates({
    required this.phone,
    required this.password,
    required this.errorMessage,
    required this.isPhoneValid,
    required this.isPasswordValid,
    required this.loginStatus,
    required this.data,
    required this.isPasswordObscured,
    required this.hasInteractedWithPassword,
    required this.hasInteractedWithPhone,
  });

  @override
  List<Object?> get props => [
    phone,
    password,
    errorMessage,
    isPasswordValid,
    isPhoneValid,
    data,
    loginStatus,
    isPasswordObscured,
    hasInteractedWithPassword,
    hasInteractedWithPhone,
  ];

  factory LoginStates.initial() {
    return const LoginStates(
      phone: '',
      password: '',
      isPhoneValid: false,
      isPasswordValid: false,
      errorMessage: null,
      loginStatus: LoginStatus.initial,
      data: null,
      isPasswordObscured: true,
      hasInteractedWithPhone: false,
      hasInteractedWithPassword: false,
    );
  }

  LoginStates copyWith({
    String? phone,
    String? password,
    bool? isPhoneValid,
    bool? isPasswordValid,
    String? errorMessage,
    Valet? data,
    LoginStatus? loginStatus,
    bool? isPasswordObscured,
    bool? hasInteractedWithPhone,
    bool? hasInteractedWithPassword,
  }) {
    return LoginStates(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      loginStatus: loginStatus ?? this.loginStatus,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      hasInteractedWithPhone: hasInteractedWithPhone ?? this.hasInteractedWithPhone,
      hasInteractedWithPassword: hasInteractedWithPassword ?? this.hasInteractedWithPassword,
    );
  }

  bool get isFormValid =>
      isPhoneValid && isPasswordValid && hasInteractedWithPhone && hasInteractedWithPassword;
}
