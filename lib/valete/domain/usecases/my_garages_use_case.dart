import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

import '../entities/my_garages.dart';

class MyGaragesUseCase {
  final IValetRepository repository;

  MyGaragesUseCase(this.repository);

  Future<Either<Failure,  List<MyGarages>>> myGarages() async {
    try {
      final result = await repository.myGarages();
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}