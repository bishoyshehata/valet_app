import 'package:equatable/equatable.dart';

 class Order extends Equatable {
  final int id;
  final String? garageName;
  final String? spotCode;
  final String clientNumber;
  final String? carImage;
  final int carType;
  final int? status;

  const Order({
    required this.id,
    required this.garageName,
    required this.carType,
    required this.spotCode,
    required this.clientNumber,
    required this.status,
     this.carImage,
  });

  factory Order.fromJson(Map<String, dynamic> json) =>
      Order(
    carType: json['carType'],
    garageName: json['garageName'],
    id: json['id'],
    spotCode: json['spotCode'],
    clientNumber: json['clientNumber'],
    carImage: json['carImage'],
status: json['status'],
  );

  @override
  List<Object?> get props => [carType, garageName,id,spotCode ,clientNumber, carImage,status];
}
