import 'package:equatable/equatable.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';

class GetGarageSpot extends Equatable {

final List<Spot> mainSpots;
final List<Spot> extraSpots;
final List<Spot> emptySpots;

  GetGarageSpot({required this.mainSpots,required this.extraSpots,required this.emptySpots});

  @override
  List<Object?> get props => [];

}