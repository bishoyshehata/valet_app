import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';
import '../../../data/models/garage/garage_model.dart';

class GarageState extends Equatable {
  final bool showExtraSlots;
  final VehicleType selectedVehicleType;
  final List<ParkingSlot> mainSlots;
  final List<ParkingSlot> extraSlots;

  const GarageState({
    required this.showExtraSlots,
    required this.selectedVehicleType,
    required this.mainSlots,
    required this.extraSlots,
  });

  GarageState copyWith({
    bool? showExtraSlots,
    VehicleType? selectedVehicleType,
    List<ParkingSlot>? mainSlots,
    List<ParkingSlot>? extraSlots,
  }) {
    return GarageState(
      showExtraSlots: showExtraSlots ?? this.showExtraSlots,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      mainSlots: mainSlots ?? this.mainSlots,
      extraSlots: extraSlots ?? this.extraSlots,
    );
  }

  @override
  List<Object?> get props => [showExtraSlots, selectedVehicleType, mainSlots, extraSlots];
}
