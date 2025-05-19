import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/controllers/re_auth/re_auth_events.dart';
import 'package:valet_app/valete/presentation/controllers/re_auth/re_auth_states.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/usecases/login_use_case.dart';

class ReAuthBloc extends Bloc<ReAuthEvent, ReAuthState> {
  final LoginUseCase loginUseCase;
  final SharedPreferences prefs;

  ReAuthBloc(this.loginUseCase, this.prefs) : super(ReAuthState()) {
    on<ShowPasswordPromptEvent>((event, emit) {
      emit(state.copyWith(status: ReAuthStatus.waitingForPassword));
    });

    on<RequestReAuth>((event, emit) async {
      emit(state.copyWith(status: ReAuthStatus.loading));

      final phone = prefs.getString('valetPhone') ?? '';
      final result = await loginUseCase.login(phone, event.password);

      result.fold(
            (error) {
          emit(state.copyWith(status: ReAuthStatus.failure, errorMessage: error.message));
          prefs.setBool('requiresReAuth', true);
        },
            (valet) {
          prefs.setString('accessToken', valet.accessToken);
          prefs.setBool('requiresReAuth', false);
          emit(state.copyWith(status: ReAuthStatus.success));
        },
      );
    });
  }
}
