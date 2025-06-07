import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

class CancelOrderUseCase {
  final IValetRepository repository;

  CancelOrderUseCase(this.repository);

  Future<Either<Failure,bool>> cancelOrder(int orderId) async {
    try {
      final result = await repository.cancelOrder(orderId);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}