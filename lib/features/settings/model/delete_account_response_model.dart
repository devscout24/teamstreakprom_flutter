import 'dart:convert';

class DeleteAccountResponseModel {
  bool? success;
  int? statusCode;
  String? message;

  DeleteAccountResponseModel({
    this.success,
    this.statusCode,
    this.message,
  });

  factory DeleteAccountResponseModel.fromRawJson(String str) =>
      DeleteAccountResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteAccountResponseModel(
        success: json['success'] as bool?,
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
      };
}
