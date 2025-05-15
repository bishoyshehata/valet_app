import 'package:valet_app/valete/domain/entities/my_orders.dart';

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
  });

  factory MyOrdersModel.fromJson(Map<String, dynamic> json) =>
      MyOrdersModel(
          id: json['id'],
          carImage: json['carImage'],
          status: json['status'],
          carType: json['carType'],
          clientId: json['client']['clientId'],
          whatsapp: json['client']['whatsapp'],
          spotId: json['spotId'],
          spot: json['spot'],
          garageId: json['garageId'],
          garage: json['garage'],
          valetId: json['valetId']);
}
