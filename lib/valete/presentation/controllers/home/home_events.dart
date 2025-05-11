import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';

abstract class HomeEvent extends Equatable {}

class PhoneNumberReceived extends HomeEvent {
  final String phoneNumber;
  PhoneNumberReceived({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}
