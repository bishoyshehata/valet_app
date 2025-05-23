import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/domain/usecases/delete_account_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'profile_events.dart';
import 'profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileState> {
  final RequestState termsState;

  final DeleteValedUseCase deleteValedUseCase;

  ProfileBloc(
    this.deleteValedUseCase, {
    int initialSelectedStatus = 0,
    this.termsState = RequestState.loading,
  }) : super(ProfileState()) {

    on<DeleteValetEvent>((event, emit) async {
      final result = await deleteValedUseCase.deleteValet(event.valetId);
      result.fold(
        (error) => emit(
          state.copyWith(
            deleteErrorMessage: error.message,
            deleteState: RequestState.error,
          ),
        ),
        (data) async {
          print(data);
          emit(
            state.copyWith(deletedata: data, deleteState: RequestState.loaded),
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
        },
      );

    });
    on<LoadTermsEvent>((event, emit) {
      emit(state.copyWith(termsState: RequestState.loading));
    });
    on<TermsLoadedEvent>((event, emit) {
      emit(state.copyWith(termsState: RequestState.loaded));
    });
    on<LogoutEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // حذف كل البيانات المحفوظة
      emit(state.copyWith(logOutState: LogOutState.loaded)); // إرسال الحالة الجديدة
    });
  }
}
