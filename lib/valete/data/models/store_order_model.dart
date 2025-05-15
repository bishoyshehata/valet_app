import 'package:valet_app/valete/domain/entities/store_order.dart';

class StoreOrderModel extends StoreOrder {
  const StoreOrderModel({
    required super.garageId,
    required super.spotId,
    required super.ClientNumber,
    required super.carType,
     super.carImageFile,
  });

  Map<String ,dynamic> toJson() =>
  {
    "garageId" :garageId ,
    "spotId" :spotId ,
    "ClientNumber" :ClientNumber ,
    "carType" :carType ,
    if (carImageFile != null) 'carImageFile': carImageFile, // مايبعتش key لو null
  };
}

