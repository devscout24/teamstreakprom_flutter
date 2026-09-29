import 'dart:convert';
import 'my_orders_response_model.dart';

class OrderDetailsResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  MyOrderData? data;

  OrderDetailsResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory OrderDetailsResponseModel.fromRawJson(String str) =>
      OrderDetailsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsResponseModel(
        success: json['success'] as bool?,
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? MyOrderData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}
