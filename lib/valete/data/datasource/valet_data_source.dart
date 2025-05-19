import 'package:dio/dio.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/valete/data/models/my_garages_models.dart';
import 'package:valet_app/valete/data/models/my_orders_model.dart';
import 'package:valet_app/valete/data/models/valet_model.dart';
import '../../../core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/store_order.dart';
import '../models/create_order_model.dart';

abstract class IValetDataSource {
  Future<ValetModel> login(String phone, String password);
  Future<CreateOrderModel> createOrder();
  Future<List<MyGaragesModel>> myGarages();
  Future<bool> storeOrder(StoreOrder storeOrder);
  Future<List<MyOrdersModel>> myOrders(int status);
  Future<bool> updateOrderStatus(int orderId,int newStatus);
  Future<bool> deleteValet(int valetId);
}
class ValetDataSource extends IValetDataSource {
  final Dio dio;
  late SharedPreferences prefs;

  ValetDataSource(this.dio);

  @override
  Future<ValetModel> login(String phone, String password) async {
    try {
      prefs = await SharedPreferences.getInstance();

      String? deviceToken = prefs.getString('deviceToken');

      final response = await dio.post(ApiConstants.baseUrl +ApiConstants.loginEndPoint, data: {
        'phone': phone,
        'password': password,
        'deviceToken':deviceToken,
      },
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {

        final result =  ValetModel.fromJson(response.data);
        prefs.setString('accessToken', result.accessToken);
        prefs.setString('valetId', result.id.toString());
        prefs.setString('valetName', result.name.toString());
        prefs.setString('companyName', result.companyName.toString());
        prefs.setString('whatsapp', result.whatsapp.toString());

        return result ;
      } else {
        throw ServerFailure( response.data['messages'][0]);
      }
    } on ServerException catch (e) {

      throw ServerException(
          errorMessageModel: e.errorMessageModel
      );

    }
  }


  @override
  Future<CreateOrderModel> createOrder() async {
    try {
      prefs = await SharedPreferences.getInstance();

      String? accessToken = prefs.getString('accessToken');

      final response = await dio.post(ApiConstants.baseUrl +ApiConstants.createOrderEndPoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' '$accessToken',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {

        return CreateOrderModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure( response.data['messages'][0]);
      }
    } on ServerException catch (e) {

      throw ServerException(
          errorMessageModel: e.errorMessageModel
      );

    }
  }

  @override
  Future< List<MyGaragesModel>> myGarages()async{
    try {
      prefs = await SharedPreferences.getInstance();

      String? accessToken = prefs.getString('accessToken');

      final response = await dio.post(ApiConstants.baseUrl +ApiConstants.myGaragesEndPoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' '$accessToken',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
           final  result = (response.data['data'] as List)
            .map((e) => MyGaragesModel.fromJson(e))
            .toList();

        return result;
      } else {
        throw ServerFailure( response.data['messages'][0]);
      }
    } on ServerException catch (e) {

      throw ServerException(
          errorMessageModel: e.errorMessageModel
      );

    }

  }

  @override
  Future<bool> storeOrder(StoreOrder storeOrder) async {
    try {
      prefs = await SharedPreferences.getInstance();

      String? accessToken = prefs.getString('accessToken');
      final formMap = {
        'ClientNumber': storeOrder.ClientNumber,
        'garageId': storeOrder.garageId,
        'spotId': storeOrder.spotId,
        'carType': storeOrder.carType,
      };
      if (storeOrder.carImageFile != null) {
        formMap['carImageFile'] = await MultipartFile.fromFile(
          storeOrder.carImageFile!.path,
        );
      }
      final formData = FormData.fromMap(formMap);
      final response = await dio.post(
        ApiConstants.baseUrl + ApiConstants.storeOrderEndPoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        final result = response.data['data'] ;
        return result;
      } else {
        throw ServerFailure( response.data['messages'][0]);
      }
    } on ServerException catch (e) {
      throw ServerException(
          errorMessageModel: e.errorMessageModel
      );

    }
  }

  @override
  Future<List<MyOrdersModel>> myOrders(int status)async {
    try {
      prefs = await SharedPreferences.getInstance();

      String? accessToken = prefs.getString('accessToken');

      final response = await dio.get(ApiConstants.baseUrl +ApiConstants.myOrdersEndPoint,
        queryParameters: {
          'status': status,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {

        final  result = (response.data['data'] as List)
            .map((e) => MyOrdersModel.fromJson(e))
            .toList();
       return result ;
      } else {
        throw ServerFailure( response.data['messages'][0]);
      }
    } on ServerException catch (e) {
      throw ServerException(
          errorMessageModel: e.errorMessageModel
      );
    }
  }

  @override
  Future<bool> updateOrderStatus(int orderId, int newStatus) async{
    try {
      prefs = await SharedPreferences.getInstance();

      String? accessToken = prefs.getString('accessToken');
      final response = await dio.post(
        ApiConstants.updateOrderStatusEndPoint(orderId,newStatus),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        final result = response.data['data'] ;
        return result;
      } else {
        throw ServerFailure( response.data['messages'][0]);
      }
    } on ServerException catch (e) {
      throw ServerException(
          errorMessageModel: e.errorMessageModel
      );

    }
  }

  @override
  Future<bool> deleteValet(int valetId) async{
    try {
      prefs = await SharedPreferences.getInstance();

      String? accessToken = prefs.getString('accessToken');
      final response = await dio.delete(
        ApiConstants.deleteValetEndPoint(valetId),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode == 200) {
        final result = response.data['succeeded'] ;
        return result;
      } else {
        throw ServerFailure( response.data['messages'][0]);
      }
    } on ServerException catch (e) {
      throw ServerException(
          errorMessageModel: e.errorMessageModel
      );

    }
  }
}
