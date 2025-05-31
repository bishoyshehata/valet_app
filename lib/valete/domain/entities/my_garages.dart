import 'package:equatable/equatable.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';

abstract class MyGarages extends Equatable {
  final int id;
  final int priority;
  final String name;
  final String? description;
  final String? address;
  final String addedOn;
  final String? companyName;
  final bool capacityOverFlow;
  final int capacity;
  final int companyId;
  final int busySpotCount;
  final int emptySpotCount;

  const MyGarages({
    required this.id,
    required this.priority,
    required this.name,
    required this.description,
    required this.address,
    required this.addedOn,
     this.companyName ,
    required this.capacityOverFlow,
    required this.capacity,
    required this.companyId,
    required this.emptySpotCount,
    required this.busySpotCount,
  });
}
