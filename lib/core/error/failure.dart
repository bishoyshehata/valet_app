import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../valete/data/datasource/valet_data_source.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, this.statusCode);

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(String message, [int? statusCode])
      : super(message, statusCode);
}
Never handleHttpError(Response? response, DioException? dioError) {
  if (response != null) {
    switch (response.statusCode) {
      case 400:
        throw ServerFailure(extractFirstErrorMessage(response.data), 400);
      case 401:
        throw ServerFailure('انتهت صلاحية الجلسة. برجاء تسجيل الدخول مرة أخرى.', 401);
      case 404:
        throw ServerFailure('يوجد خطأ بالبيانات', 404);
      case 500:
        throw ServerFailure('حدث خطأ داخلي في الخادم. يرجى المحاولة لاحقًا.', 500);
      default:
        throw ServerFailure('حدث خطأ غير متوقع. رمز الخطأ: ${response.statusCode}', response.statusCode ?? 0);
    }
  } else if (dioError != null) {
    if (dioError.type == DioExceptionType.connectionTimeout ||
        dioError.type == DioExceptionType.receiveTimeout ||
        dioError.type == DioExceptionType.sendTimeout) {
      throw ServerFailure('انتهت مهلة الاتصال بالخادم. حاول مرة أخرى.', 0);
    } else if (dioError.type == DioExceptionType.connectionError) {
      throw ServerFailure('لا يوجد اتصال بالإنترنت. تحقق من الشبكة.', 0);
    } else if (dioError.type == DioExceptionType.cancel) {
      throw ServerFailure('تم إلغاء الطلب.', 0);
    } else if (dioError.type == DioExceptionType.badResponse) {
      final statusCode = dioError.response?.statusCode ?? 0;
      final message = extractFirstErrorMessage(dioError.response?.data) ?? 'خطأ غير معروف من السيرفر.';
      throw ServerFailure(message, statusCode);
    } else {
      throw ServerFailure('حدث خطأ غير متوقع أثناء الاتصال بالخادم.', 0);
    }
  } else {
    throw ServerFailure('حدث خطأ غير متوقع.', 0);
  }
}

String extractFirstErrorMessage(dynamic errorData) {
  print(errorData);
  if (errorData == null) return "حدث خطأ غير متوقع";

  if (errorData is String) {
    try {
      errorData = jsonDecode(errorData);
    } catch (_) {
      return errorData; // لو نص عادي يرجع كما هو
    }
  }

  if (errorData is Map && errorData.containsKey('errors')) {
    final errors = errorData['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstKey = errors.keys.first;
      final firstErrorList = errors[firstKey];
      if (firstErrorList is List && firstErrorList.isNotEmpty) {
        return firstErrorList.join(', ');
      }
    }
  }

  if (errorData is Map && errorData.containsKey('messages')) {
    return errorData['messages'][0].toString();
  }

  return "حدث خطأ غير متوقع";
}




// class LocalDataBaseFailure extends Failure {
//  const LocalDataBaseFailure( super.message);
//
// }