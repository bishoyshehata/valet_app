import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_events.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginStates.initial()) {
    on<PhoneChanged>((event, emit) {
      final isValid = _validatePhone(event.phone);
      emit(
        state.copyWith(
          loginStatus: LoginStatus.initial,
          phone: event.phone,
          isPhoneValid: isValid,
          hasInteractedWithPhone: true,
        ),
      );
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
        final result = await loginUseCase.login(state.phone, state.password);
        result.fold(
              (error) {
            emit( state.copyWith(
              loginStatus: LoginStatus.error,
              errorMessage: error.message,

            ));
          },
              (valet) {
                return emit(
                    state.copyWith(loginStatus: LoginStatus.success, data: valet)
                );
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

bool _validatePhone(String phone) {
  final regex = RegExp(r'^(010|011|012|015)[0-9]{8}$');
  return regex.hasMatch(phone);
}

bool _validatePassword(String password) {
  return password.length >= 8;
}
