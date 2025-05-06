import 'package:dio/dio.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/valete/data/models/valet_model.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';

abstract class IValetDataSource {
Future<ValetModel> login (String phone , String password);
}

class ValetDataSource extends IValetDataSource {
  @override
  Future<ValetModel> login (String phone , String password) async {
    final response = await Dio().post(ApiConstants.baseUrl,
      data: {
        'phone': phone,
        'password': password,
        'MobileName': "requestModel.mobileName",
        'MobileModel': "requestModel.mobileModel",
        'OSVersion': "requestModel.osVersion",
        'DeviceId': "requestModel.deviceId",
        'DeviceToken':"deviceToken" ,
      },
    );
    if(response.statusCode == 200){
      return ValetModel.fromJson(response.data);
    }
    throw ServerException(errorMessageModel: ErrorMessageModel.fromjson(response.data));
  }

}