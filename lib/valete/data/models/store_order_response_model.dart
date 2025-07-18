class OrdersResponseModel {
  final String? data;
  final bool? succeeded;
  final String? message;

  OrdersResponseModel({
    this.data,
    this.succeeded,
    this.message,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      data: json['data'] as String?,
      succeeded: json['succeeded'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': data,
      'succeeded': succeeded,
      'message': message,
    };
  }
}