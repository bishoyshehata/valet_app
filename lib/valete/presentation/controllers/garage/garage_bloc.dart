import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/enums.dart';
import '../../../data/models/garage/garage_model.dart';
import 'garage_events.dart';
import 'garage_states.dart';

class GarageBloc extends Bloc<GarageEvent, GarageState> {
  GarageBloc()
      : super(
    GarageState(
      showExtraSlots: false,
      selectedVehicleType: VehicleType.car,
      mainSlots: List.generate(
        18,
            (index) => ParkingSlot(
              name: "P "+ "${index+1}",
          id: index + 1,
          isOccupied: [2, 4, 5, 7, 8, 11, 12, 14, 15].contains(index + 1),
          isSelected: (index + 1) == 2,
        ),
      ),
      extraSlots: List.generate(
        8,
            (index) => ParkingSlot(id: 19 + index, isOccupied: index.isEven, name: "P "+ "${19+index}"),
      ),
    ),
  ) {
    on<ToggleExtraSlotsEvent>((event, emit) {
      emit(state.copyWith(showExtraSlots: !state.showExtraSlots));
    });

    on<SelectVehicleTypeEvent>((event, emit) {
      emit(state.copyWith(selectedVehicleType: event.type));
    });
  }
}
