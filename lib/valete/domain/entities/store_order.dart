import 'package:equatable/equatable.dart';

class StoreOrder extends Equatable {
  final int garageId;
  final int spotId;
  final String clientNumber;
  final int carType;
  final String carImage;

  const StoreOrder({
    required this.garageId,
    required this.spotId,
    required this.clientNumber,
    required this.carType,
    required this.carImage,
  });

  @override
  List<Object?> get props => [garageId,spotId,clientNumber,carType,carImage];
}

class StoreOrderResponse extends Equatable {
  final bool data;


  const StoreOrderResponse({
    required this.data,

  });

  @override
  List<Object?> get props => [data];
}
