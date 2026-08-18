import 'dart:convert';

class ResendRegisterOtpModel {
  bool? success;
  int? statusCode;
  String? message;

  ResendRegisterOtpModel({this.success, this.statusCode, this.message});

  factory ResendRegisterOtpModel.fromRawJson(String str) =>
      ResendRegisterOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResendRegisterOtpModel.fromJson(Map<String, dynamic> json) =>
      ResendRegisterOtpModel(
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
