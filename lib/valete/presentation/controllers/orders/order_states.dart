import 'dart:io';
import 'dart:typed_data';
import 'package:valet_app/valete/domain/entities/create_order.dart';

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
  final String garageName;
  final StoreOrderState storeOrderState;
  final String storeOrderError;
  final int storeOrderStatusCode;
  final bool? storeOrderData;
  final ImageProcessingStatus? imageStatus;
  final String? errorMessage;
  final bool hasInteractedWithPhone;
  final String? completePhoneNumber;
  final String? phoneErrorMessage;
  final bool isPhoneValid;
  final bool? useWhatsApp;

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
    this.garageName = 'اسم الجراج',
    this.storeOrderState = StoreOrderState.initial,
    this.storeOrderError = '',
    this.storeOrderStatusCode = 0,
    this.createOrderStatusCode = 0,
    this.storeOrderData,
    this.errorMessage,
    this.imageStatus,
     this.hasInteractedWithPhone = false,
     this.completePhoneNumber = '',
     this.phoneErrorMessage =null,
     this.isPhoneValid =false,
     this.useWhatsApp,

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
    String? garageName,
    StoreOrderState? storeOrderState,
     String? storeOrderError,
     int? storeOrderStatusCode,
    bool? storeOrderData,
    ImageProcessingStatus? imageStatus,
    String? errorMessage,
     bool? hasInteractedWithPhone,
     String? completePhoneNumber,
     String? phoneErrorMessage,
     bool? isPhoneValid,
     bool? useWhatsApp,
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
      garageName: garageName ?? this.garageName,
      storeOrderState: storeOrderState ?? this.storeOrderState,
      storeOrderError: storeOrderError ?? this.storeOrderError,
      storeOrderStatusCode: storeOrderStatusCode ?? this.storeOrderStatusCode,
      storeOrderData: storeOrderData ?? this.storeOrderData,
      imageStatus: imageStatus ?? this.imageStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      hasInteractedWithPhone: hasInteractedWithPhone ?? this.hasInteractedWithPhone,
      completePhoneNumber: completePhoneNumber ?? this.completePhoneNumber,
      phoneErrorMessage: phoneErrorMessage ?? this.phoneErrorMessage,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      useWhatsApp: useWhatsApp ?? this.useWhatsApp,
    );
  }
  bool? get isAllValid => isPhoneValid && hasInteractedWithPhone;
}
