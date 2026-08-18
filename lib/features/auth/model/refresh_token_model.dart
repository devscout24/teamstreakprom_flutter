import 'dart:convert';

class RefreshTokenModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  RefreshTokenModel({this.success, this.statusCode, this.message, this.data});

  factory RefreshTokenModel.fromRawJson(String str) =>
      RefreshTokenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => RefreshTokenModel(
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
  String? accessToken;

  Data({
    this.accessToken,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["accessToken"],
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
  };
}
