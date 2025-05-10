import 'package:valet_app/valete/domain/entities/valet.dart';

class ValetModel extends Valet {
  const ValetModel({
    required super.id,
    required super.phone,
    required super.name,
    required super.accessToken,
    required super.deviceToken,
    required super.status,
    required super.whatsapp,
    required super.password,
    required super.addedOn,
    required super.companyName,
    required super.companyId,
  });

  factory ValetModel.fromJson(Map<String, dynamic> json) {
    return ValetModel(
      id: json['data']['id'],
      phone: json['data']['phone'],
      name: json['data']['name'],
      accessToken: json['data']['accessToken'],
      deviceToken: json['data']['deviceToken'],
      status: json['data']['status'],
      whatsapp: json['data']['whatsapp'],
      password: json['data']['password'],
      addedOn: json['data']['addedOn'],
      companyName: json['data']['companyName'],
      companyId: json['data']['companyId'],
    );
  }
}
