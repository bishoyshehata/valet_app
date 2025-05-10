import 'package:dio/dio.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/valete/data/models/valet_model.dart';
import '../../../core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/create_order_model.dart';

abstract class IValetDataSource {
  Future<ValetModel> login(String phone, String password);
  Future<CreateOrderModel> createOrder();
}
class ValetDataSource extends IValetDataSource {
  final Dio dio;

  ValetDataSource(this.dio);

  @override
  Future<ValetModel> login(String phone, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final response = await dio.post(ApiConstants.baseUrl +ApiConstants.loginEndPoint, data: {
        'phone': phone,
        'password': password,
        'DeviceToken': 'abc-456',
      },
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {

        final result =  ValetModel.fromJson(response.data);
        prefs.setString('accessToken', result.accessToken);
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
      final prefs = await SharedPreferences.getInstance();
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
}
