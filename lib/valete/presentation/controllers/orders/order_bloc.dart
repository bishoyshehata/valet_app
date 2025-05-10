import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'order_events.dart';
import 'order_states.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  CreateOrderUseCase createOrderUseCase;

  OrderBloc(this.createOrderUseCase)
      : super(OrderState(selectedVehicleType: VehicleType.car)) {
    on<SelectVehicleType>((event, emit) {
      emit(state.copyWith(selectedVehicleType: event.vehicleType));
      // print(event.vehicleType.name);
    });
    on<PickImageEvent>((event, emit) async {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.camera);
      if (pickedFile != null) {
        emit(state.copyWith(image: File(pickedFile.path)));
      }
    });

    on<CreateOrderEvent>((event, emit) async {
      emit(state.copyWith(createOrderState: RequestState.loading));
      final order = await createOrderUseCase.createOrder();
      order.fold((error) =>
          emit(state.copyWith(createOrderState: RequestState.error,
              createOrderError: error.message)), (data) =>emit(state.copyWith(createOrderState: RequestState.loaded,
          data: data)) ,);
    });
  }
}
