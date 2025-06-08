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
  factory UpdateValetModel.fromJson(Map<String, dynamic> json) {
    return UpdateValetModel(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      companyId: json['companyId'] ?? 0,
      status: json['status'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'whatsapp': whatsapp,
      'companyId': companyId,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id,name,phone,password,whatsapp,companyId,status];
}
