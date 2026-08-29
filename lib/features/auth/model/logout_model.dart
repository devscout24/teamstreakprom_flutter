import 'dart:convert';

class LogoutModel {
  bool? success;
  int? statusCode;
  String? message;

  LogoutModel({this.success, this.statusCode, this.message});

  LogoutModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
  }) => LogoutModel(
    success: success ?? this.success,
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
  );

  factory LogoutModel.fromRawJson(String str) =>
      LogoutModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LogoutModel.fromJson(Map<String, dynamic> json) => LogoutModel(
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
