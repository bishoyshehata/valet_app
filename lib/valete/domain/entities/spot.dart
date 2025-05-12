import 'package:equatable/equatable.dart';

class Spot extends Equatable {
  final int id;
  final int status;
  final String code;
  final String addedOn;
  final int garageId;

  const Spot({
    required this.id,
    required this.status,
    required this.code,
    required this.garageId,
    required this.addedOn,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'],
      status: json['status'],
      code: json['code'],
      garageId: json['garageId'],
      addedOn: json['addedOn'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    status,
    code,
    garageId,
    addedOn,
  ];
}