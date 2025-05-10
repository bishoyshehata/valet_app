import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/entities/create_order.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

class CreateOrderUseCase {
  final IValetRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, CreateOrder>> createOrder() async {
    try {
      final result = await repository.createOrder();

      return result;
    } catch (e) {

      return Left(ServerFailure(e.toString()));
    }
  }
}