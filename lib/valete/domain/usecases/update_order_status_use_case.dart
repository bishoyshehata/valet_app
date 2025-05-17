import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

class UpdateOrderStatusUseCase {
  final IValetRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure,  bool >> updateOrderStatus(int orderId , int newStatus) async {
    try {
      final result = await repository.updateOrderStatus(orderId ,newStatus);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}