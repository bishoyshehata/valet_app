import 'package:valet_app/valete/domain/entities/store_order.dart';

class StoreOrderModel extends StoreOrder {
  const StoreOrderModel({
    required super.garageId,
    required super.spotId,
    required super.clientNumber,
    required super.carType,
     super.carImage,
  });

  Map<String ,dynamic> toJson() =>
  {
    "garageId" :garageId ,
    "spotId" :spotId ,
    "clientNumber" :clientNumber ,
    "carType" :carType ,
    if (carImage != null) 'carImage': carImage, // مايبعتش key لو null
  };
}

