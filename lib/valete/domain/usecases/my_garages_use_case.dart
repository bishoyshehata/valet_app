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
  Future<Either<Failure, List<MyGarages>>> myGarages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isUnAuth = prefs.getBool('unAuthorized');

    try {
      final result = await repository.myGarages();
      print('Repository result: $result');
      return result;
    } on ServerFailure catch (e) {
      print('ServerFailure caught in UseCase: ${e.message}, statusCode: ${e.statusCode}');
      if (isUnAuth == true) {
        sl<LoginBloc>().add(TokenExpiredEvent());
      }
      return Left(e);
    }
  }

}