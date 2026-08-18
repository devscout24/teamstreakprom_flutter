import 'dart:convert';

class ForgotPasswordModel {
  bool? success;
  int? statusCode;
  String? message;

  ForgotPasswordModel({this.success, this.statusCode, this.message});

  factory ForgotPasswordModel.fromRawJson(String str) =>
      ForgotPasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
  };
}
