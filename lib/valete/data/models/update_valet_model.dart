import 'package:equatable/equatable.dart';

class UpdateValetModel extends Equatable {
  final int id;

  final String name;

  final String phone;

  final String password;

  final String whatsapp;

  final int companyId;

  final int status;

  UpdateValetModel(
  { required this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.whatsapp,
    required this.companyId,
    required this.status,}
  );


  @override
  List<Object?> get props => [id,name,phone,password,whatsapp,companyId,status];
}
