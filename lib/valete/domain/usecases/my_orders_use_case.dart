import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/entities/my_orders.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

import '../../../core/services/services_locator.dart';
import '../../presentation/controllers/login/login_bloc.dart';
import '../../presentation/controllers/login/login_events.dart';

class MyOrdersUseCase {
  final IValetRepository repository;

  MyOrdersUseCase(this.repository);

  Future<Either<Failure,  List<MyOrders> >> myOrders(int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isUnAuth = prefs.getBool('unAuthorized');
    try {
      final result = await repository.myOrders(status);
      return result;
    } catch (e) {
      if(isUnAuth == true){
        sl<LoginBloc>().add(TokenExpiredEvent());
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}