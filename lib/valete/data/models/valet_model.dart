import 'package:valet_app/valete/domain/entities/valet.dart';

class ValetModel extends Valet {
  const ValetModel({
    required super.id,
    required super.phone,
    required super.name,
    required super.role,
  });

  factory ValetModel.fromJson(Map<String, dynamic> json) {
    return ValetModel(
      id: json['data']['id'],
      phone: json['data']['phone'],
      name: json['data']['name'],
      role: json['data']['role'],
    );
  }
}
