import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';
import '../../data/models/update_valet_model.dart';


class UpdateValetUseCase {
  final IValetRepository repository;

  UpdateValetUseCase(this.repository);

  Future<Either<Failure,  UpdateValetModel >> updateValet(UpdateValetModel model) async {
    try {
      final result = await repository.updateValet(model);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}