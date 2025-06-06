import 'dart:io';
import 'dart:typed_data';
import 'package:valet_app/valete/domain/entities/default_order.dart';

import '../../../../core/utils/enums.dart';

class OrderState {
  final VehicleType selectedVehicleType;
  final File? image;
  final Uint8List? imageBytes;
  final bool isLoading;
  final RequestState defaultOrderState;
  final String createOrderError;
  final int createOrderStatusCode;
  final CreateOrder? data;
  final String phoneNumber;
  final String spotName;
  final StoreOrderState storeOrderState;
  final String storeOrderError;
  final bool? storeOrderData;
  final ImageProcessingStatus? imageStatus;
  final String? errorMessage;

  OrderState({
    this.data,
    this.defaultOrderState = RequestState.loading,
    this.createOrderError = '',
    required this.selectedVehicleType,
    this.image = null,
    this.imageBytes,
    this.isLoading = false,
    this.phoneNumber = 'رقم هاتف العميل',
    this.spotName = 'رقم الباكية',
    this.storeOrderState = StoreOrderState.initial,
    this.storeOrderError = '',
    this.createOrderStatusCode = 0,
    this.storeOrderData,
    this.errorMessage,
    this.imageStatus,
  });

  OrderState copyWith({
    VehicleType? selectedVehicleType,
    File? image,
    Uint8List? imageBytes,
    bool? isLoading,
    RequestState? defaultOrderState,
    String? createOrderError,
    int? createOrderStatusCode,
    CreateOrder? data,
    String? phoneNumber,
    String? spotName,
    StoreOrderState? storeOrderState,
     String? storeOrderError,
    bool? storeOrderData,
    ImageProcessingStatus? imageStatus,
    String? errorMessage,
  }) {
    return OrderState(
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      image: image ?? this.image,
      imageBytes: imageBytes ?? this.imageBytes,
      isLoading: isLoading ?? this.isLoading,
      defaultOrderState: defaultOrderState ?? this.defaultOrderState,
      createOrderError: createOrderError ?? this.createOrderError,
      createOrderStatusCode: createOrderStatusCode ?? this.createOrderStatusCode,
      data: data ?? this.data,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      spotName: spotName ?? this.spotName,
      storeOrderState: storeOrderState ?? this.storeOrderState,
      storeOrderError: storeOrderError ?? this.storeOrderError,
      storeOrderData: storeOrderData ?? this.storeOrderData,
      imageStatus: imageStatus ?? this.imageStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
