import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

class DeleteValedUseCase {
  final IValetRepository repository;

  DeleteValedUseCase(this.repository);

  Future<Either<Failure,bool>> deleteValet(int valetId) async {
    try {
      final result = await repository.deleteValet(valetId);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}