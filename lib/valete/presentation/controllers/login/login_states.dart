import 'package:equatable/equatable.dart';
import 'package:valet_app/valete/data/models/valet_model.dart';
import '../../../domain/entities/valet.dart';

class LoginStates extends Equatable {
  final String phone;
  final String password;
  final bool isPhoneValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final Valet? data ;
  final bool isPasswordObscured;


  const LoginStates({
    required this.phone,
    required this.password,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
    required this.isPhoneValid,
    required this.isPasswordValid,
    required this.data,
    this.isPasswordObscured = true,

  });

  @override
  List<Object?> get props => [phone, password, isSubmitting,isSuccess,errorMessage,isPasswordValid, isPhoneValid,data];
  factory LoginStates.initial() {
    return LoginStates(
      phone: '',
      password: '',
      isSubmitting: false,
      isPhoneValid: false,
      isPasswordValid: false,
      isSuccess: false,
      errorMessage: null,
      data:null ,
    );
  }

  LoginStates copyWith({
    String? phone,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isPhoneValid,
    bool? isPasswordValid,
    String? errorMessage,
    Valet ? data

  }) {
    return LoginStates(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      data: data
    );
  }
  bool get isFormValid => isPhoneValid && isPasswordValid;

}
