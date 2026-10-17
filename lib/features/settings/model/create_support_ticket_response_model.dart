import 'dart:convert';
import 'my_support_tickets_model.dart';

class CreateSupportTicketResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  SupportTicketItem? data;

  CreateSupportTicketResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CreateSupportTicketResponseModel.fromRawJson(String str) =>
      CreateSupportTicketResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateSupportTicketResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CreateSupportTicketResponseModel(
        success: json['success'] as bool?,
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? SupportTicketItem.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}
