import 'package:equatable/equatable.dart';

class CreateOrder extends Equatable {
  final int garageId;
  final int spotId;
  final String qr;
  final String garageName;
  final String garageAddress;
  final String spotName;
  final bool isOverFlow;
  final int capacityEmpty;
  final int capacityFull;
  final int totalBusy;

  const CreateOrder({
    required this.garageId,
    required this.spotId,
    required this.qr,
    required this.garageName,
    required this.garageAddress,
    required this.spotName,
    required this.isOverFlow,
    required this.capacityEmpty,
    required this.capacityFull,
    required this.totalBusy,
  });

  @override
  List<Object?> get props => [
    garageId,
    spotId,
    qr,
    garageName,
    garageAddress,
    spotName,
    isOverFlow,
    capacityEmpty,
    capacityFull,
    totalBusy,
  ];
}
