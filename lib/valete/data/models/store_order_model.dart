import 'package:valet_app/valete/domain/entities/store_order.dart';

class StoreOrderModel extends StoreOrder {
  const StoreOrderModel({
    required super.garageId,
    required super.spotId,
    required super.clientNumber,
    required super.carType,
    required super.carImage,
  });

  Map<String ,dynamic> toJson() =>
  {
    "garageId" :garageId ,
    "spotId" :spotId ,
    "clientNumber" :clientNumber ,
    "carType" :carType ,
    "carImage" :carImage ,
  };
}


class StoreOrderResponseModel extends StoreOrderResponse {
    const StoreOrderResponseModel({required super.data});


  factory StoreOrderResponseModel.fromJson(Map<String, dynamic> json)=>
      StoreOrderResponseModel(
        data: json['data'] ?? false,

      );

}
