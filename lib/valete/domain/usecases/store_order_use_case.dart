
import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/entities/default_order.dart';
import 'package:valet_app/valete/domain/entities/store_order.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

import '../entities/my_garages.dart';

class StoreOrderUseCase {
  final IValetRepository repository;

  StoreOrderUseCase(this.repository);

  Future<Either<Failure,  bool >> storeOrder(StoreOrder storeOrder) async {
    try {
      final result = await repository.storeOrder(storeOrder);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}