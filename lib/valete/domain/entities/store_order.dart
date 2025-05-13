import 'package:equatable/equatable.dart';

class StoreOrder extends Equatable {
  final int garageId;
  final int spotId;
  final String clientNumber;
  final int carType;
  final String? carImage;

  const StoreOrder({
    required this.garageId,
    required this.spotId,
    required this.clientNumber,
    required this.carType,
     this.carImage,
  });

  @override
  List<Object?> get props => [garageId,spotId,clientNumber,carType,carImage];
}
