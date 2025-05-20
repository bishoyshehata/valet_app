import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/valet.dart';

class LoginStates extends Equatable {
  final String password;
  final bool isPhoneValid;
  final bool isPasswordValid;
  final String? errorMessage;
  final Valet? data;
  final LoginStatus loginStatus;
  final bool isPasswordObscured;
  final bool hasInteractedWithPhone;
  final bool hasInteractedWithPassword;
  final String completePhoneNumber;
  final String? phoneErrorMessage;
  final ReAuthStatus reAuthStatus;
  final String reAuthError;

  const LoginStates({
    required this.password,
    required this.errorMessage,
    required this.isPhoneValid,
    required this.isPasswordValid,
    required this.loginStatus,
    required this.data,
    required this.isPasswordObscured,
    required this.hasInteractedWithPassword,
    required this.hasInteractedWithPhone,
    required this.completePhoneNumber,
    required this.phoneErrorMessage,
    required this.reAuthStatus,
    required this.reAuthError,
  });

  @override
  List<Object?> get props => [
    completePhoneNumber,
    password,
    errorMessage,
    isPasswordValid,
    isPhoneValid,
    data,
    loginStatus,
    isPasswordObscured,
    hasInteractedWithPassword,
    hasInteractedWithPhone,
    phoneErrorMessage,
    reAuthStatus,
    reAuthError,
  ];

  factory LoginStates.initial() {
    return const LoginStates(
      completePhoneNumber: '',
      password: '',
      isPhoneValid: false,
      isPasswordValid: false,
      errorMessage: null,
      loginStatus: LoginStatus.initial,
      data: null,
      isPasswordObscured: true,
      hasInteractedWithPhone: false,
      hasInteractedWithPassword: false,
      phoneErrorMessage: null,
      reAuthStatus: ReAuthStatus.initial,
      reAuthError: '',
    );
  }

  LoginStates copyWith({
    String? completePhoneNumber,
    String? password,
    bool? isPhoneValid,
    bool? isPasswordValid,
    String? errorMessage,
    String? phoneErrorMessage,
    Valet? data,
    LoginStatus? loginStatus,
    bool? isPasswordObscured,
    bool? hasInteractedWithPhone,
    bool? hasInteractedWithPassword,
    ReAuthStatus? reAuthStatus,
    String? reAuthError,
  }) {
    return LoginStates(
      completePhoneNumber: completePhoneNumber ?? this.completePhoneNumber,
      password: password ?? this.password,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      loginStatus: loginStatus ?? this.loginStatus,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      hasInteractedWithPhone:
          hasInteractedWithPhone ?? this.hasInteractedWithPhone,
      hasInteractedWithPassword:
          hasInteractedWithPassword ?? this.hasInteractedWithPassword,
      phoneErrorMessage: phoneErrorMessage,
      reAuthStatus: reAuthStatus ?? this.reAuthStatus,
      reAuthError: reAuthError ?? this.reAuthError,
    );
  }

  bool get isFormValid =>
      isPhoneValid &&
      isPasswordValid &&
      hasInteractedWithPhone &&
      hasInteractedWithPassword;
}
