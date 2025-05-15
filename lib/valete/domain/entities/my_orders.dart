import 'package:equatable/equatable.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';
import 'my_garages.dart';

class MyOrders extends Equatable {
  final int id;
  final String? carImage;
  final int status;
  final int carType;
  final int clientId;
  final String whatsapp;
  final int spotId;
  final Spot spot;
  final int garageId;
  final MyGarages garage;
  final int valetId;

  const MyOrders({
    required this.id,
    required this.carImage,
    required this.status,
    required this.carType,
    required this.clientId,
    required this.whatsapp,
    required this.spotId,
    required this.spot,
    required this.garageId,
    required this.garage,
    required this.valetId,
  });

  @override
  List<Object?> get props => [
    id,
    carImage,
    status,
    carType,
    clientId,
    whatsapp,
    spotId,
    spot,
    garageId,
    garage,
    valetId,
  ];
}
