import 'dart:convert';

class VerifyRegisterOtpModel {
  bool? success;
  int? statusCode;
  String? message;

  VerifyRegisterOtpModel({this.success, this.statusCode, this.message});

  factory VerifyRegisterOtpModel.fromRawJson(String str) =>
      VerifyRegisterOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyRegisterOtpModel.fromJson(Map<String, dynamic> json) =>
      VerifyRegisterOtpModel(
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
