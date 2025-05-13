import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../domain/entities/spot.dart';

class MyGaragesModel extends MyGarages {
 const MyGaragesModel({
    required super.id,
    required super.priority,
    required super.name,
    required super.description,
    required super.address,
    required super.addedOn,
    required super.capacityOverFlow,
    required super.capacity,
    required super.companyId,
    required super.spots,
  });

 factory MyGaragesModel.fromJson(Map<String, dynamic> json)=>
     MyGaragesModel(
       id: json['id'],
       priority: json['priority'],
       name: json['name'],
       description: json['description'],
       address: json['address'],
       addedOn: json['addedOn'],
       capacityOverFlow: json['capacityOverFlow'],
       capacity: json['capacity'],
       companyId: json['companyId'],
       spots:  (json['spots'] as List)
           .map((spot) => Spot.fromJson(spot))
           .toList(),
     );



 @override
  List<Object?> get props => [];
}
