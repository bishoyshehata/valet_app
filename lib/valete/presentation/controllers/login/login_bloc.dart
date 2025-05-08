import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_events.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginStates.initial()) {


    on<CompletePhoneChanged>((event, emit) {
      final isValid = validatePhoneByCountry(event.countryCode, event.phoneNumber);

      emit(state.copyWith(
        completePhoneNumber: '+${event.countryCode}${event.phoneNumber}',
        isPhoneValid: isValid,
        loginStatus: LoginStatus.initial,
        hasInteractedWithPhone: true,
        phoneErrorMessage : isValid ? null : 'رقم الهاتف غير صحيح بالنسبة للدولة المختارة',
      ));
    });





    on<PasswordChanged>((event, emit) {
      final isValid = _validatePassword(event.password);
      emit(
        state.copyWith(
          loginStatus: LoginStatus.initial,

          password: event.password,
          isPasswordValid: isValid,
          hasInteractedWithPassword: true,
        ),
      );
    });

    on<TogglePasswordVisibility>((event, emit) {

      emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured,loginStatus: LoginStatus.initial,));
    });
    on<ResetLoginStatus>((event, emit) {
      emit(
        state.copyWith(loginStatus: LoginStatus.initial, errorMessage: null),
      );
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(loginStatus: LoginStatus.loading));

      if (state.isFormValid) {
        final result = await loginUseCase.login(state.completePhoneNumber.replaceFirst("+", ''), state.password);
        result.fold(
              (error) {
            emit(state.copyWith(
              loginStatus: LoginStatus.error,
              errorMessage: error.message,
            ));
          },
              (valet) {
            emit(state.copyWith(loginStatus: LoginStatus.success, data: valet));
          },
        );
      } else {
        emit(
          state.copyWith(
            loginStatus: LoginStatus.error,
            errorMessage: "أسف و لكن عليك إستكمال بياناتك",
          ),
        );
      }
    });

  }
}
bool validatePhoneByCountry(String countryCode, String nationalNumber) {
  print('🔍 Validating for countryCode: $countryCode | number: $nationalNumber');

  switch (countryCode) {
    case '20':
      final isValid = nationalNumber.startsWith(RegExp(r'^(10|11|12|15)'));
      print('✅ Egypt validation: $isValid');
      return isValid;
    case '966':
      final isValid = nationalNumber.startsWith('5');
      print('✅ KSA validation: $isValid');
      return isValid;
    case '971':
      final isValid = nationalNumber.startsWith('5');
      print('✅ UAE validation: $isValid');
      return isValid;
    default:
      print('⚠️ Unknown country, accepted by default');
      return true;
  }
}




bool _validatePassword(String password) {
  return password.length >= 8;
}
