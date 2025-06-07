import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';
import '../entities/settings.dart';

class SettingsUseCase {
  final IValetRepository repository;

  SettingsUseCase(this.repository);
  Future<Either<Failure, Settings>> settings() async {

    try {
      final result = await repository.settings();
      return result;
    } on ServerFailure catch (e) {
      print('ServerFailure caught in UseCase: ${e.message}, statusCode: ${e.statusCode}');
      return Left(e);
    }
  }

}