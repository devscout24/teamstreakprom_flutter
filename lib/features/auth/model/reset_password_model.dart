import 'dart:convert';

class ResetPasswordModel {
  bool? success;
  int? statusCode;
  String? message;

  ResetPasswordModel({this.success, this.statusCode, this.message});

  factory ResetPasswordModel.fromRawJson(String str) =>
      ResetPasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordModel(
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
