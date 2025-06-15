import 'package:valet_app/valete/domain/entities/my_orders.dart';

import '../../domain/entities/spot.dart';
import 'my_garages_models.dart';

class MyOrdersModel extends MyOrders {
  const MyOrdersModel({
    required super.id,
    required super.carImage,
    required super.status,
    required super.carType,
    required super.clientId,
    required super.whatsapp,
    required super.spotId,
    required super.spot,
    required super.garageId,
    required super.garage,
    required super.valetId,
    required super.addedOn,
  });

  factory MyOrdersModel.fromJson(Map<String, dynamic> json) =>
      MyOrdersModel(
          id: json['id'],
          carImage: json['carImage'],
          status: json['status'],
          carType: json['carType'],
          addedOn: json['addedOn'],
          clientId: json['client']['id'],
          whatsapp: json['client']['whatsapp'],
          spotId: json['spotId'],
          spot: Spot.fromJson(json['spot']),
          garageId: json['garageId'],
          garage: MyGaragesModel.fromJson(json['garage']),
          valetId: json['valetId']);
}
