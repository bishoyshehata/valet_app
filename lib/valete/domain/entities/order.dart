import 'package:equatable/equatable.dart';

 class Order extends Equatable {
  final int id;
  final String garageName;
  final String spotCode;
  final int carType;

  const Order({
    required this.id,
    required this.garageName,
    required this.carType,
    required this.spotCode,
  });

  factory Order.fromJson(Map<String, dynamic> json) =>
      Order(
    carType: json['carType'],
    garageName: json['garageName'],
    id: json['id'],
    spotCode: json['spotCode'],
  );

  @override
  List<Object?> get props => [carType, garageName,id,spotCode];
}
