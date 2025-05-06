import 'package:equatable/equatable.dart';

abstract class Valet extends Equatable {
final int id ;
final String phone ;
final String name ;
final String role ;

const Valet({required this.id, required this.phone , required this.name,required this.role});

@override
List<Object> get props =>[id,name,phone,role];


}