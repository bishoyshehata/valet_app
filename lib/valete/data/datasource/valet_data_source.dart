import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/valete/data/models/get_garage_spot_model.dart';
import 'package:valet_app/valete/data/models/my_garages_models.dart';
import 'package:valet_app/valete/data/models/my_orders_model.dart';
import 'package:valet_app/valete/data/models/valet_model.dart';
import 'package:valet_app/valete/domain/entities/get_garage_spot.dart';
import '../../../core/dio/dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/notifications/firebase_notifications/firebase.dart';
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
  Future<GetGarageSpotModel> getGarageSpot(int garageId);
  Future<bool> updateOrderSpot(int orderId , int spotId,int garageId);
}


class ValetDataSource extends IValetDataSource {
  final Dio dio ;
  late SharedPreferences prefs;

  ValetDataSource(this.dio);

  @override
  Future<ValetModel> login(String phone, String password) async {
    try {
      prefs = await SharedPreferences.getInstance();
      final fcmToken = await FirebaseFcm.getFcmToken();

      final response = await DioHelper.post(
        ApiConstants.loginEndPoint,
        data: {
          'phone': phone,
          'password': password,
          'deviceToken': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        final result = ValetModel.fromJson(response.data);
        prefs.setString('accessToken', result.accessToken);
        prefs.setString('valetId', result.id.toString());
        prefs.setString('valetName', result.name.toString());
        prefs.setString('companyName', result.companyName.toString());
        prefs.setString('whatsapp', result.whatsapp.toString());
        prefs.setString('valetPhone', result.phone.toString());
        return result;
      }
      else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }


  @override
  Future<CreateOrderModel> createOrder() async {
    try {
      final response = await DioHelper.post(
        ApiConstants.createOrderEndPoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return CreateOrderModel.fromJson(response.data['data']);
      } else {
        handleHttpError(response, null); // ترمي الخطأ
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }
  Future<List<MyGaragesModel>> myGarages() async {
    try {
      final response = await DioHelper.post(
        ApiConstants.myGaragesEndPoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => MyGaragesModel.fromJson(e))
            .toList();
      } else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }
  @override
  Future<bool> storeOrder(StoreOrder storeOrder) async {
    try {
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

      final response = await DioHelper.post(
        ApiConstants.storeOrderEndPoint,
        data: formMap,
        isFormData: true,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }

  @override
  Future<List<MyOrdersModel>> myOrders(int status) async {
    try {
      final response = await DioHelper.get(
        ApiConstants.myOrdersEndPoint,
        query: {'status': status},
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => MyOrdersModel.fromJson(e))
            .toList();
      } else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }

  @override
  Future<bool> updateOrderStatus(int orderId, int newStatus) async {
try {
    final response = await DioHelper.post(
      ApiConstants.updateOrderStatusEndPoint(orderId, newStatus),
      requiresAuth: true,
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      handleHttpError(response, null);
    }
} on DioException catch (e) {
  handleHttpError(e.response, e);
}
  }
  @override
  Future<bool> deleteValet(int valetId) async {
    try {
      final response = await DioHelper.delete(
        ApiConstants.deleteValetEndPoint(valetId),
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return response.data['succeeded'];
      } else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }

  @override
  Future<GetGarageSpotModel> getGarageSpot(int garageId) async {
    try {
      final response = await DioHelper.post(
        ApiConstants.getGarageSpotEndPoint(garageId),
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return GetGarageSpotModel.fromJson(response.data['data']);
      } else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }

  @override
  Future<bool> updateOrderSpot(int orderId, int spotId, int garageId) async {
    try {
      final response = await DioHelper.post(
        ApiConstants.updateOrderSpotEndPoint(orderId, spotId, garageId),
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }

Future<void> markUnAuthorized() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('unAuthorized', true);
  print("Marked as Unauthorized: ${prefs.getBool('unAuthorized')}");
}
}