import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/store_order_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'order_events.dart';
import 'order_states.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  CreateOrderUseCase createOrderUseCase;
  StoreOrderUseCase storeOrderUseCase;
  OrderBloc(this.createOrderUseCase,this.storeOrderUseCase)
      : super(OrderState(selectedVehicleType: VehicleType.Car)) {
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
      emit(state.copyWith(defaultOrderState: RequestState.loading));
      final order = await createOrderUseCase.createOrder();
      order.fold((error) =>
          emit(state.copyWith(defaultOrderState: RequestState.error,
              createOrderError: error.message)), (data) {
        emit(state.copyWith(defaultOrderState: RequestState.loaded,
            data: data));
      },);
    });

    on<UpdatePhoneNumberEvent>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    });

    on<UpdateSpotNameEvent>((event, emit) {
      emit(state.copyWith(spotName: event.spotName));
    });

    on<StoreOrderEvent>((event, emit) async {
      emit(state.copyWith(storeOrderState: StoreOrderState.loading));

        final result = await storeOrderUseCase.storeOrder(event.storeData);
        result.fold(
              (error) {

            emit(state.copyWith(
              storeOrderState: StoreOrderState.error,
              storeOrderError: error.message,
            ));
          },
              (data) {
                print(data);

            emit(state.copyWith(storeOrderState: StoreOrderState.loaded, storeOrderData: data));
          },
        );
    });


  }
}



