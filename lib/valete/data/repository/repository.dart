import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/data/datasource/valet_data_source.dart';
import 'package:valet_app/valete/domain/entities/default_order.dart';
import 'package:valet_app/valete/domain/entities/get_garage_spot.dart';
import 'package:valet_app/valete/domain/entities/my_garages.dart';
import 'package:valet_app/valete/domain/entities/my_orders.dart';
import 'package:valet_app/valete/domain/entities/store_order.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';


class ValetRepository extends IValetRepository {
  final IValetDataSource valetDataSource;
  ValetRepository(this.valetDataSource);

  @override
  Future<Either<Failure, Valet>> login(String phone, String password) async {
    try {
      final result = await valetDataSource.login(phone, password);
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }

  @override
  Future<Either<Failure, CreateOrder>> createOrder() async{
    try {
      final result = await valetDataSource.createOrder();
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }
  @override
  Future<Either<Failure,  List<MyGarages> >> myGarages() async{
    try {
      final result = await valetDataSource.myGarages();
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> storeOrder(StoreOrder storeOrder) async{
    try {
      final result = await valetDataSource.storeOrder(storeOrder);
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<MyOrders>>> myOrders(int status) async {
    try {
      final result = await valetDataSource.myOrders(status);
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> updateOrderStatus(int orderId, int newStatus) async {
    try {
      final result = await valetDataSource.updateOrderStatus(orderId,newStatus);
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteValet(int valetId)async {
    try {
      final result = await valetDataSource.deleteValet(valetId);
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }

  @override
  Future<Either<Failure, GetGarageSpot>> getGarageSpot(int garageId)async {

    try {
      final result = await valetDataSource.getGarageSpot(garageId);
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }

  @override
  Future<Either<Failure, bool>> updateOrderSpot(int orderId, int spotId,int garageId) async{
    try {
      final result = await valetDataSource.updateOrderSpot(orderId , spotId, garageId);
      return Right(result);
    } on ServerFailure catch (failure) {
      return Left(ServerFailure(failure.message , failure.statusCode));
    }
  }
}
