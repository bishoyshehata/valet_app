import 'package:equatable/equatable.dart';

abstract class Valet extends Equatable {
  final int id;

  final String phone;

  final String name;

  final String? deviceToken;

  final String whatsapp;

  final String status;

  final String accessToken;

  const Valet({
    required this.id,
    required this.phone,
    required this.name,
    required this.accessToken,
    required this.deviceToken,
    required this.status,
    required this.whatsapp,
  });

  @override
  List<Object> get props => [id, name, phone,accessToken,deviceToken ?? "",status, whatsapp];
}
