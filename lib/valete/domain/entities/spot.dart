import 'package:equatable/equatable.dart';

import 'order.dart';

class Spot extends Equatable {
  final int id;
  final int status;
  final String code;
  final String? addedOn;
  final int? garageId;
  final Order? order;

  const Spot({
    required this.id,
    required this.status,
    required this.code,
     this.garageId,
     this.addedOn,
     this.order,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'],
      status: json['status'],
      code: json['code'],
      garageId: json['garageId'],
      addedOn: json['addedOn'],
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    status,
    code,
    garageId,
    addedOn,
    order
  ];
}