import 'package:valet_app/valete/domain/entities/default_order.dart';

import '../../domain/entities/spot.dart';

class CreateOrderModel extends CreateOrder {
  CreateOrderModel({
    required super.garageId,
    required super.spotId,
    required super.qr,
    required super.garageName,
    required super.garageAddress,
    required super.spotName,
    required super.isOverFlow,
    required super.capacityEmpty,
    required super.capacityFull,
    required super.totalBusy,
    required super.spots,
  });

  factory CreateOrderModel.fromJson(Map<String, dynamic> json)=>
      CreateOrderModel(
          garageId: json['garageId'],
          spotId: json['spotId'],
          qr: json['qr'],
          garageName: json['garageName'],
          garageAddress: json['garageAddress'],
          spotName: json['spotName'],
          isOverFlow: json['isOverFlow'],
          capacityEmpty: json['capacityEmpty'],
          capacityFull: json['capacityFull'],
          totalBusy: json['totalBusy'],
          spots:  (json['spots'] as List<dynamic>)
              .map((spotJson) => Spot(
            id: spotJson['id'],
            status: spotJson['status'],
            code: spotJson['code'],
            garageId: spotJson['garageId'],
            addedOn: spotJson['addedOn'],
            hasOrder: spotJson['hasOrder'],
          ))
              .toList(),
          );

}
