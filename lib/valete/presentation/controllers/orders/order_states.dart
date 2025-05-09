import 'dart:io';
import '../../../../core/utils/enums.dart';

class OrderState {
  final VehicleType selectedVehicleType;
  final File? image;

  OrderState({
    required this.selectedVehicleType,
    this.image,
  });

  OrderState copyWith({
    VehicleType? selectedVehicleType,
    File? image,
  }) {
    return OrderState(
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      image: image ?? this.image,
    );
  }
}
