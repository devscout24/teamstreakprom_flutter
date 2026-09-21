import 'dart:convert';

class StripeConnectResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  StripeConnectData? data;

  StripeConnectResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory StripeConnectResponseModel.fromRawJson(String str) =>
      StripeConnectResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StripeConnectResponseModel.fromJson(Map<String, dynamic> json) =>
      StripeConnectResponseModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StripeConnectData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class StripeConnectData {
  String? stripeAccountId;
  String? url;

  StripeConnectData({
    this.stripeAccountId,
    this.url,
  });

  factory StripeConnectData.fromRawJson(String str) =>
      StripeConnectData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StripeConnectData.fromJson(Map<String, dynamic> json) =>
      StripeConnectData(
        stripeAccountId: json["stripeAccountId"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "stripeAccountId": stripeAccountId,
        "url": url,
      };
}
