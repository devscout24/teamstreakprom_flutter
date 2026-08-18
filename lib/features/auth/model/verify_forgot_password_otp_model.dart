import 'dart:convert';

class VerifyForgotPasswordOtpModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  VerifyForgotPasswordOtpModel({this.success, this.statusCode, this.message, this.data});

  factory VerifyForgotPasswordOtpModel.fromRawJson(String str) =>
      VerifyForgotPasswordOtpModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyForgotPasswordOtpModel.fromJson(Map<String, dynamic> json) =>
      VerifyForgotPasswordOtpModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? resetToken;

  Data({
    this.resetToken,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    resetToken: json["resetToken"],
  );

  Map<String, dynamic> toJson() => {
    "resetToken": resetToken,
  };
}
