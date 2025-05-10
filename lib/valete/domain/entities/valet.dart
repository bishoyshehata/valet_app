import 'package:equatable/equatable.dart';

abstract class Valet extends Equatable {
  final int id;
  final String phone;
  final String name;
  final String? deviceToken;
  final String whatsapp;
  final String password;
  final String addedOn;
  final String? companyName;
  final int status;
  final int companyId;
  final String accessToken;

  const Valet({
    required this.id,
    required this.phone,
    required this.name,
    required this.accessToken,
    required this.deviceToken,
    required this.status,
    required this.whatsapp,
    required this.password,
    required this.addedOn,
    required this.companyName,
    required this.companyId,
  });

  @override
  List<Object> get props => [
    id,
    name,
    phone,
    accessToken,
    deviceToken ?? "",
    status,
    whatsapp,
    password,
    addedOn,
    companyName ?? "",
    companyId,
  ];
}
