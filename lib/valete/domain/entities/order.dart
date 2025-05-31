import 'package:equatable/equatable.dart';

 class Order extends Equatable {
  final int id;
  final String? garageName;
  final String? spotCode;
  final String clientNumber;
  final String? carImage;
  final int carType;

  const Order({
    required this.id,
    required this.garageName,
    required this.carType,
    required this.spotCode,
    required this.clientNumber,
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
  );

  @override
  List<Object?> get props => [carType, garageName,id,spotCode ,clientNumber, carImage];
}
