import 'package:valet_app/valete/domain/entities/valet.dart';

class ValetModel extends Valet {
  ValetModel({
    required super.id,
    required super.phone,
    required super.name,
    required super.accessToken,
    required super.deviceToken,
    required super.status,
    required super.whatsapp,
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
    );
  }
}
