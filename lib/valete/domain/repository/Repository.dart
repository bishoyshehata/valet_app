import 'package:dartz/dartz.dart';
import 'package:valet_app/valete/data/models/get_garage_spot_model.dart';
import 'package:valet_app/valete/data/models/update_valet_model.dart';
import 'package:valet_app/valete/domain/entities/default_order.dart';
import 'package:valet_app/valete/domain/entities/my_garages.dart';
import 'package:valet_app/valete/domain/entities/my_orders.dart';
import 'package:valet_app/valete/domain/entities/settings.dart';
import 'package:valet_app/valete/domain/entities/store_order.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';

import '../../../core/error/failure.dart';
import '../entities/get_garage_spot.dart';

abstract class IValetRepository{

  Future<Either<Failure , Valet>> login(String phone , String password);
  Future<Either<Failure , CreateOrder>> createOrder();
  Future<Either<Failure , List<MyGarages>>> myGarages();
  Future<Either<Failure , bool >> storeOrder(StoreOrder storeOrder);
  Future<Either<Failure , List<MyOrders> >> myOrders(int status);
  Future<Either<Failure , bool >> updateOrderStatus(int orderId , int newStatus);
  Future<Either<Failure , bool >> deleteValet(int valetId);
  Future<Either<Failure , GetGarageSpot >> getGarageSpot(int garageId);
  Future<Either<Failure , bool >> updateOrderSpot(int orderId , int spotId ,int garageId);
  Future<Either<Failure , bool >> cancelOrder(int orderId);
  Future<Either<Failure , Settings >> settings();
  Future<Either<Failure , UpdateValetModel >> updateValet(UpdateValetModel);

}