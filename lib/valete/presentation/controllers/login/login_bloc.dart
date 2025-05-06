import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_events.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_states.dart';
class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginUseCase loginUseCase ;
  LoginBloc(this.loginUseCase)
    : super(LoginStates.initial(),){

    on<PhoneChanged>((event, emit) {
      final isValid = _validatePhone(event.phone);
      emit(state.copyWith(phone: event.phone, isPhoneValid: isValid,errorMessage: null));
    });

    on<PasswordChanged>((event, emit) {
      final isValid = _validatePassword(event.password);
      emit(state.copyWith(password: event.password, isPasswordValid: isValid,errorMessage: null));
    });

    // لما المستخدم يضغط زرار تسجيل الدخول
    on<LoginSubmitted>((event, emit) async {
      if (!state.isFormValid) {
        emit(state.copyWith(errorMessage: 'InValid Credentials'));
        return;
      }
      emit(state.copyWith(isSubmitting: true, errorMessage: null));


      final result = await loginUseCase.login(state.phone, state.password);
      result.fold((error)=>emit(state.copyWith(errorMessage: error.message,isSuccess: false,isSubmitting: false)),
          (valet)=>emit(state.copyWith(data: valet,isSuccess: true,isSubmitting: false)));
    }
    );
  }
}

  bool _validatePhone(String phone) {
    final regex = RegExp(r'^(010|011|012|015)[0-9]{8}$');
    return regex.hasMatch(phone);
  }

  bool _validatePassword(String password) {
    return password.length >= 8;
  }

