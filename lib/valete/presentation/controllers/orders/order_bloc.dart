import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/store_order_use_case.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/enums.dart';
import '../myorders/my_orders_bloc.dart';
import '../myorders/my_orders_events.dart';
import 'order_events.dart';
import 'order_states.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  CreateOrderUseCase createOrderUseCase;
  StoreOrderUseCase storeOrderUseCase;
  OrderBloc(this.createOrderUseCase,this.storeOrderUseCase)
      : super(OrderState(selectedVehicleType: VehicleType.Car)) {
    on<SelectVehicleType>((event, emit) {
      emit(state.copyWith(selectedVehicleType: event.vehicleType));
    });

    on<PickImageEvent>((event, emit) async {
      try {
        final picker = ImagePicker();
        final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();
          final originalImage = img.decodeImage(bytes);

          if (originalImage == null) {
            emit(state.copyWith(errorMessage: "تعذر في قراءة الصورة"));
            return;
          }

          // تحويل لـ JPEG
          final jpegData = img.encodeJpg(originalImage);
          final tempDir = await getTemporaryDirectory();
          final jpegFile = File(join(tempDir.path, 'converted_${DateTime.now().millisecondsSinceEpoch}.jpg'));

          await jpegFile.writeAsBytes(jpegData);

          emit(state.copyWith(image: jpegFile, errorMessage: ""));
        }
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });


    on<CreateOrderEvent>((event, emit) async {
      emit(state.copyWith(defaultOrderState: RequestState.loading));
      final order = await createOrderUseCase.createOrder();
      order.fold((error) {
        print(error.statusCode);
        emit(state.copyWith(defaultOrderState: RequestState.error,
            createOrderError: error.message ,createOrderStatusCode:  error.statusCode));
      }
          , (data) {
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
    on<UpdateGarageNameEvent>((event, emit) {
      emit(state.copyWith(garageName: event.garageName));
    });
    on<CompletePhoneChanged>((event, emit) {
      final isValid = validateOrderPhoneByCountry(event.countryCode, event.phoneNumber);

      emit(state.copyWith(
        completePhoneNumber: '+${event.countryCode}${event.phoneNumber}',
        isPhoneValid: isValid,
        hasInteractedWithPhone: true,
        phoneErrorMessage : isValid ? null : 'رقم الهاتف غير صحيح بالنسبة للدولة المختارة',
      ));
    });

    on<StoreOrderNoWhatsAppEvent>((event, emit) async {
      emit(state.copyWith(storeOrderState: StoreOrderState.loading));
        if(state.isAllValid!){
        final result = await storeOrderUseCase.storeOrder(event.storeData);
        result.fold(
              (error) {
                print(error.statusCode);

            emit(state.copyWith(
              storeOrderState: StoreOrderState.error,
              storeOrderError: error.message,
              createOrderStatusCode: error.statusCode
            ));
          },
              (data) {
            emit(state.copyWith(storeOrderState: StoreOrderState.loaded, storeOrderData: data));
            MyOrdersBloc(sl(),sl(),sl()).add(GetAllMyOrdersEvent());
            MyOrdersBloc(sl(),sl(),sl()).add(GetMyOrdersEvent(0),);

          },
        );}else{
          emit(state.copyWith(
              storeOrderState: StoreOrderState.error,
              storeOrderError :"أسف و لكن رقم الهاتف خطأ",
          ));
        }
    });
    on<StoreOrderWithWhatsAppEvent>((event, emit) async {
      emit(state.copyWith(storeOrderState: StoreOrderState.loading));
        final result = await storeOrderUseCase.storeOrder(event.storeData);
        result.fold(
              (error) {
                print(error.statusCode);
            emit(state.copyWith(
              storeOrderState: StoreOrderState.error,
              storeOrderError: error.message,
              createOrderStatusCode: error.statusCode
            ));
          },
              (data) {
            emit(state.copyWith(storeOrderState: StoreOrderState.loaded, storeOrderData: data));
            MyOrdersBloc(sl(),sl(),sl()).add(GetAllMyOrdersEvent());
            MyOrdersBloc(sl(),sl(),sl()).add(GetMyOrdersEvent(0),);

          },
        );
    });


  }
}

bool validateOrderPhoneByCountry(String countryCode, String nationalNumber) {

  switch (countryCode) {
    case '+20':
      final isValid = nationalNumber.startsWith(RegExp(r'^(10|11|12|15)'));
      return isValid;
    case '+966':
      final isValid = nationalNumber.startsWith('5');
      return isValid;
    case '+971':
      final isValid = nationalNumber.startsWith('5');
      return isValid;
    default:
      return true;
  }
}

