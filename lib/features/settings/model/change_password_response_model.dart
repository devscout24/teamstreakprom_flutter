import 'dart:convert';

class ChangePasswordResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  dynamic data;

  ChangePasswordResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ChangePasswordResponseModel.fromRawJson(String str) =>
      ChangePasswordResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponseModel(
        success: json['success'] as bool?,
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        if (data != null) 'data': data,
      };
}
