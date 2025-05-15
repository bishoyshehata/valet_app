import 'dart:io';

import 'package:equatable/equatable.dart';

class StoreOrder extends Equatable {
  final int garageId;
  final int spotId;
  final String ClientNumber;
  final int carType;
  final File? carImageFile;

  const StoreOrder({
    required this.garageId,
    required this.spotId,
    required this.ClientNumber,

    required this.carType,
     this.carImageFile,
  });

  @override
  List<Object?> get props => [garageId,spotId,ClientNumber,carType,carImageFile];
}
