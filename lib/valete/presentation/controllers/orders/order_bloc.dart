import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/enums.dart';
import 'order_events.dart';
import 'order_states.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {

  OrderBloc() : super(OrderState(selectedVehicleType: VehicleType.car)) {

    on<SelectVehicleType>((event, emit) {
      emit(state.copyWith(selectedVehicleType: event.vehicleType));
       // print(event.vehicleType.name);
    });

    on<PickImageEvent>((event, emit) async {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        emit(state.copyWith(image: File(pickedFile.path)));
      }
    });


  }
}
