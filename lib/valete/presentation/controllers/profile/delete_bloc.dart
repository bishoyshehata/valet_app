import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/delete_account_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'delete_events.dart';
import 'delete_states.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {

  final DeleteValedUseCase deleteValedUseCase;

  DeleteBloc(
    this.deleteValedUseCase, {
    int initialSelectedStatus = 0,
  }) : super( DeleteState()) {


    on<DeleteValetEvent>((event, emit) async {
      final result = await deleteValedUseCase.deleteValet(event.valetId);
      result.fold(
        (error) => emit(

          state.copyWith(
            deleteErrorMessage: error.message,
            deleteState: RequestState.error,
          ),
        ),
        (data) {
          print(data);
          emit(
            state.copyWith(deletedata: data, deleteState: RequestState.loaded),
          );
        },
      );
    });
  }
}
