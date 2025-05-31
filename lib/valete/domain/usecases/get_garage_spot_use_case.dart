import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/entities/get_garage_spot.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

class GetGarageSpotUseCase {
  final IValetRepository repository;

  GetGarageSpotUseCase(this.repository);

  Future<Either<Failure,GetGarageSpot>> getGarageSpot(int garageId) async {
    try {
      final result = await repository.getGarageSpot(garageId);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}