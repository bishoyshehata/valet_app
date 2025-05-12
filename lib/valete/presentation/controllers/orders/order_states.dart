import 'dart:io';
import 'dart:typed_data';
import 'package:valet_app/valete/domain/entities/create_order.dart';

import '../../../../core/utils/enums.dart';

class OrderState {
  final VehicleType selectedVehicleType;
  final File? image;
  final Uint8List? imageBytes;
  final bool isLoading;
  final RequestState createOrderState;
  final String createOrderError;
  final CreateOrder? data;
  final String phoneNumber;
  final String spotName;


  OrderState({
    this.data,
     this.createOrderState = RequestState.loading,
     this.createOrderError = '',
    required this.selectedVehicleType,
    this.image,
    this.imageBytes,
    this.isLoading = false,
    this.phoneNumber = 'رقم هاتف العميل',
    this.spotName = 'رقم الباكية',


  });

  OrderState copyWith({
    VehicleType? selectedVehicleType,
    File? image,
    Uint8List? imageBytes,
    bool? isLoading,
    RequestState? createOrderState,
     String? createOrderError,
     CreateOrder? data,
    String? phoneNumber,
    String? spotName,



  }) {
    return OrderState(
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      image: image ?? this.image,
      imageBytes: imageBytes ?? this.imageBytes,
      isLoading: isLoading ?? this.isLoading,
      createOrderState: createOrderState ?? this.createOrderState,
      createOrderError: createOrderError ?? this.createOrderError,
      data: data ?? this.data,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      spotName: spotName ?? this.spotName,

    );
  }
}
