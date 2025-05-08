import 'package:dio/dio.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/valete/data/models/valet_model.dart';
import '../../../core/error/exceptions.dart';

abstract class IValetDataSource {
  Future<ValetModel> login(String phone, String password);
}
class ValetDataSource extends IValetDataSource {
  final Dio dio;

  ValetDataSource(this.dio);

  @override
  Future<ValetModel> login(String phone, String password) async {
    try {
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
        return ValetModel.fromJson(response.data);
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
