import 'package:dartz/dartz.dart';
import 'package:valet_app/valete/domain/entities/default_order.dart';
import 'package:valet_app/valete/domain/entities/my_garages.dart';
import 'package:valet_app/valete/domain/entities/my_orders.dart';
import 'package:valet_app/valete/domain/entities/store_order.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';

import '../../../core/error/failure.dart';

abstract class IValetRepository{

  Future<Either<Failure , Valet>> login(String phone , String password);
  Future<Either<Failure , CreateOrder>> createOrder();
  Future<Either<Failure , List<MyGarages>>> myGarages();
  Future<Either<Failure , bool >> storeOrder(StoreOrder storeOrder);
  Future<Either<Failure , List<MyOrders> >> myOrders(int status);
  Future<Either<Failure , bool >> updateOrderStatus(int orderId , int newStatus);

}