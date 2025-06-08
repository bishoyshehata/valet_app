// dio_helper.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_constants.dart';

class DioHelper {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => true,
    ),
  );

  static Future<void> _setAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static Future<Response> post(
      String url, {
        Map<String, dynamic>? data,
        bool requiresAuth = false,
        bool isFormData = false,
      }) async {
    if (requiresAuth) await _setAuthHeader();

    return await _dio.post(
      url,
      data: isFormData ? FormData.fromMap(data ?? {}) : data,
      options: Options(
        contentType: isFormData ? 'multipart/form-data' : 'application/json',
      ),
    );
  }
  static Future<Response> put(
      String url, {
        Map<String, dynamic>? data,
        bool requiresAuth = false,
        bool isFormData = false,
      }) async {
    if (requiresAuth) await _setAuthHeader();

    return await _dio.put(
      url,
      data: isFormData ? FormData.fromMap(data ?? {}) : data,
      options: Options(
        contentType: isFormData ? 'multipart/form-data' : 'application/json',
      ),
    );
  }


  static Future<Response> get(
      String url, {
        Map<String, dynamic>? query,
        bool requiresAuth = false,
      }) async {
    if (requiresAuth) await _setAuthHeader();
    return await _dio.get(url, queryParameters: query);
  }

  static Future<Response> delete(
      String url, {
        bool requiresAuth = false,
      }) async {
    if (requiresAuth) await _setAuthHeader();
    return await _dio.delete(url);
  }
}
