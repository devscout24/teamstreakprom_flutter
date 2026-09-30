import 'dart:convert';

class RedeemRewardRequestModel {
  final String itemType;
  final String itemId;
  final int quantity;

  RedeemRewardRequestModel({
    this.itemType = "MARKETPLACE",
    required this.itemId,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      "itemType": itemType,
      "itemId": itemId,
      "quantity": quantity,
    };
  }

  String toRawJson() => json.encode(toJson());
}

class RedeemRewardResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final dynamic data;

  RedeemRewardResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory RedeemRewardResponseModel.fromRawJson(String str) =>
      RedeemRewardResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RedeemRewardResponseModel.fromJson(Map<String, dynamic> json) {
    return RedeemRewardResponseModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }
}
