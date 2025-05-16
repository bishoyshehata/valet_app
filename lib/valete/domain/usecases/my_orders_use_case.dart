import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/entities/my_orders.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

class MyOrdersUseCase {
  final IValetRepository repository;

  MyOrdersUseCase(this.repository);

  Future<Either<Failure,  List<MyOrders> >> myOrders(int status) async {
    try {
      final result = await repository.myOrders(status);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}