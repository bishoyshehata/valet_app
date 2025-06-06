import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

import '../../../core/services/services_locator.dart';
import '../../presentation/controllers/login/login_bloc.dart';
import '../../presentation/controllers/login/login_events.dart';
import '../entities/my_garages.dart';

class MyGaragesUseCase {
  final IValetRepository repository;

  MyGaragesUseCase(this.repository);

  Future<Either<Failure,  List<MyGarages>>> myGarages() async {
    try {
      final result = await repository.myGarages();
      return result;
    }  catch (e) {
  // ... (check for isUnAuth)

  if (e is Failure) {
  // Return the original Failure to preserve statusCode
  return Left(e);
  } else {
  // Wrap unexpected errors
  print("Caught unexpected error in MyGaragesUseCase: $e");
  return Left(ServerFailure(e.toString()));
  }
  }

}
}