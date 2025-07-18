import 'package:dio/dio.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/valete/data/models/get_garage_spot_model.dart';
import 'package:valet_app/valete/data/models/my_garages_models.dart';
import 'package:valet_app/valete/data/models/my_orders_model.dart';
import 'package:valet_app/valete/data/models/settings_model.dart';
import 'package:valet_app/valete/data/models/update_valet_model.dart';
import 'package:valet_app/valete/data/models/valet_model.dart';
import '../../../core/dio/dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/notifications/firebase_notifications/firebase.dart';
import '../../domain/entities/store_order.dart';
import '../models/create_order_model.dart';
import 'dart:convert';

import '../models/store_order_response_model.dart';


abstract class IValetDataSource {
  Future<ValetModel> login(String phone, String password);
  Future<CreateOrderModel> createOrder();
  Future<List<MyGaragesModel>> myGarages();
  Future<OrdersResponseModel> storeOrder(StoreOrder storeOrder);
  Future<List<MyOrdersModel>> myOrders(int status);
  Future<OrdersResponseModel> updateOrderStatus(int orderId,int newStatus);
  Future<bool> deleteValet(int valetId);
  Future<GetGarageSpotModel> getGarageSpot(int garageId);
  Future<bool> updateOrderSpot(int orderId , int spotId,int garageId);
  Future<bool> cancelOrder(int orderId);
  Future<SettingsModel> settings();
  Future<UpdateValetModel> updateValet(UpdateValetModel model);

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
        prefs.setInt('valetId', result.id);
        prefs.setString('valetName', result.name.toString());
        prefs.setInt('companyId', result.companyId);
        prefs.setString('companyName', result.companyName.toString());
        // prefs.setString('password', result.companyName.toString());
        prefs.setString('whatsapp', result.whatsapp.toString());
        prefs.setString('valetPhone', result.phone.toString());
        prefs.setInt('status', result.status);
        print(prefs.getInt('statusIndex'));
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
  Future<OrdersResponseModel> storeOrder(StoreOrder storeOrder) async {
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
        return OrdersResponseModel.fromJson(response.data);
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
  Future<OrdersResponseModel> updateOrderStatus(int orderId, int newStatus) async {
try {
    final response = await DioHelper.post(
      ApiConstants.updateOrderStatusEndPoint(orderId, newStatus),
      requiresAuth: true,
    );

    if (response.statusCode == 200) {
      return OrdersResponseModel.fromJson(response.data);
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
  @override
  Future<bool> cancelOrder(int orderId)async {
    try {
      final response = await DioHelper.delete(
        ApiConstants.cancelOrderEndPoint(orderId),
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
  Future<SettingsModel> settings()async {
      try {
        final response = await DioHelper.get(
          ApiConstants.settings,
          requiresAuth: false,
        );

        if (response.statusCode == 200) {
          return SettingsModel.fromJson(response.data);
        } else {
          handleHttpError(response, null);
        }
      } on DioException catch (e) {
        handleHttpError(e.response, e);
      }
    }

  @override
  Future<UpdateValetModel> updateValet(UpdateValetModel model) async{
    try {
      prefs = await SharedPreferences.getInstance();

      final response = await DioHelper.put(
        ApiConstants.updateValetEndPoint,
        data: {
          "id": model.id,
          "name": model.name,
          "phone": model.phone,
          "password":model.password,
          "whatsapp": model.whatsapp,
          "companyId": model.companyId,
          "status": model.status,
        },
      );

      if (response.statusCode == 200) {
        final result = UpdateValetModel.fromJson(response.data['data']);
        prefs.setInt('valetId', result.id);
        prefs.setString('valetName', result.name.toString());
        prefs.setInt('companyId', result.companyId);
        prefs.setString('whatsapp', result.whatsapp.toString());
        prefs.setString('valetPhone', result.phone.toString());
        prefs.setString('password', '123123123');
        prefs.setInt('status', result.status);
        print(prefs.getInt('statusIndex'));
        return result;
      }
      else {
        handleHttpError(response, null);
      }
    } on DioException catch (e) {
      handleHttpError(e.response, e);
    }
  }
  }
