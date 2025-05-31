import 'package:valet_app/valete/domain/entities/get_garage_spot.dart';

import '../../domain/entities/spot.dart';

class GetGarageSpotModel extends GetGarageSpot {
  GetGarageSpotModel({
    required super.mainSpots,
    required super.extraSpots,
    required super.emptySpots,
  });

  factory GetGarageSpotModel.fromJson(Map<String, dynamic>json) =>
      GetGarageSpotModel(
          mainSpots: (json['mainSpots'] as List)
              .map((e) => Spot.fromJson(e))
              .toList(),
          extraSpots: (json['extraSpots']as List).map((e)=>Spot.fromJson(e)).toList(),
          emptySpots: (json['emptySpots']as List).map((e)=>Spot.fromJson(e)).toList(),);
}
