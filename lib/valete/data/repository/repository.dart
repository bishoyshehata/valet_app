import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/data/datasource/valet_data_source.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

import '../../../core/error/exceptions.dart';

class ValetRepository extends IValetRepository{

  final IValetDataSource valetDataSource ;
  ValetRepository(this.valetDataSource);

  @override
  Future<Either<Failure, Valet>> login(String phone, String password)async {
    final result = await valetDataSource.login(phone, password);

    try{
      return Right(result);

    }on ServerException catch(failur) {
      return Left(ServerFailure(failur.errorMessageModel.statusMessage));

    }

  }

}