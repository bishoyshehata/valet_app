import 'package:equatable/equatable.dart';

class ErrorMessageModel<T> extends Equatable {
  final T? data;
  final List<String>? messages;
  final bool? succeeded;

  const ErrorMessageModel({
    this.data, this.messages,  this.succeeded
  });

  factory ErrorMessageModel.fromjson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      data: json['data'],
      messages: (json['messages'] as List?)?.cast<String>(),
      succeeded: json['succeeded'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [data,messages,succeeded];
}
