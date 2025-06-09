import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/domain/usecases/delete_account_use_case.dart';
import 'package:valet_app/valete/domain/usecases/settings_use_case.dart';
import 'package:valet_app/valete/domain/usecases/update_valet_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'profile_events.dart';
import 'profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileState> {
  final RequestState termsState;

  final DeleteValedUseCase deleteValedUseCase;
  final SettingsUseCase settingsUseCase;
  final UpdateValetUseCase updateValetUseCase;
  ProfileBloc(
    this.deleteValedUseCase,
      this.settingsUseCase,
    this.updateValetUseCase,
      {
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
    on<GetSettingsEvent>((event, emit) async {
      final result = await settingsUseCase.settings();

      result.fold((error) {
        print(error.statusCode);
        print(error);
        emit(state.copyWith(
          settingErrorMessage: error.message,
          settingsState: RequestState.error,
          settingsStatusCode: error.statusCode,
        ));
      }, (settings) async {
        print(settings.whatsappSettings.isWorking);
        emit(state.copyWith(
          settingsData: settings,
          settingsState: RequestState.loaded,
            isWhatsAppWorking: settings.whatsappSettings.isWorking
        ));
      });
    });
    on<ChangeStatusEvent>((event, emit) {
      emit(state.copyWith(
        selectedStatus: event.status,
        isStatusChanged: true,
      ));
    });


    on<UpdateValetEvent>((event, emit) async {
      emit(state.copyWith(updateValetState: RequestStatess.loading));

      final result = await updateValetUseCase.updateValet(event.model);

      result.fold(
            (error) {
          emit(state.copyWith(
            updateValetErrorMessage: error.message,
            updateValetState: RequestStatess.error,
            updateValetStatusCode: error.statusCode,
          ));
        },
            (data) async {
          print(Status.values[data.status]);
          emit(state.copyWith(
            updateValetData: data,
            updateValetState: RequestStatess.loaded,
            updateValetStatusCode: 200,
            isStatusChanged: false,
            selectedStatus: Status.values[data.status],
          ));
        },
      );
    });



  }
}