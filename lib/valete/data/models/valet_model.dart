import 'package:valet_app/valete/domain/entities/valet.dart';

class ValetModel extends Valet {
  ValetModel({
    required super.id,
    required super.phone,
    required super.name,
    required super.role,
  });

  factory ValetModel.fromJson(Map<String, dynamic> json) {
    return ValetModel(
      id: json['id'],
      phone: json['phone'],
      name: json['name'],
      role: json['role'],
    );
  }
}
