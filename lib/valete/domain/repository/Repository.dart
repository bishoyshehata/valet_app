import 'package:dartz/dartz.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';

import '../../../core/error/failure.dart';

abstract class IValetRepository{

  Future<Either<Failure , Valet>> login(String phone , String password);
}