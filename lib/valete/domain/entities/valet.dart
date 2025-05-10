import 'package:equatable/equatable.dart';

abstract class Valet extends Equatable {
  final int id;

  final String phone;

  final String name;

  final String? deviceToken;

  final String whatsapp;

  final int status;

  final String accessToken;

  final String addedOn;
  final String companyName;
  final int companyId;

  const Valet({
    required this.id,
    required this.phone,
    required this.name,
    required this.accessToken,
    required this.deviceToken,
    required this.status,
    required this.whatsapp,
    required this.addedOn,
    required this.companyId,
    required this.companyName
  });

  @override
  List<Object> get props => [id, name, phone,accessToken,deviceToken ?? "",status, whatsapp,addedOn,companyName,companyId];
}