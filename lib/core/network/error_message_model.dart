import 'package:equatable/equatable.dart';
class ErrorMessageModel<T> extends Equatable {
  final T? data;
  final List<String>? messages;
  final bool? succeeded;
  final int? statusCode; // إضافة خاصية statusCode

  const ErrorMessageModel({
    this.data,
    this.messages,
    this.succeeded,
    this.statusCode, // ضمن الكونستركتور
  });
  factory ErrorMessageModel.fromjson(
      Map<String, dynamic> json, {
        int? statusCode,
      }) {
    return ErrorMessageModel(
      data: json['data'],
      messages: (json['messages'] as List?)?.cast<String>(),
      succeeded: json['succeeded'],
      statusCode: statusCode,
    );
  }


  @override
  List<Object?> get props => [data, messages, succeeded, statusCode];
}
