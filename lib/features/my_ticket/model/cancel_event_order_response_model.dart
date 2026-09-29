import 'dart:convert';

class CancelEventOrderResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  CancelEventOrderData? data;

  CancelEventOrderResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CancelEventOrderResponseModel.fromRawJson(String str) =>
      CancelEventOrderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancelEventOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      CancelEventOrderResponseModel(
        success: json['success'] as bool?,
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? CancelEventOrderData.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}

class CancelEventOrderData {
  String? orderId;
  String? eventId;
  String? eventTitle;
  num? totalAmountRefunded;
  int? totalTicketsCancelled;
  String? stripeRefundId;
  DateTime? cancelledAt;

  CancelEventOrderData({
    this.orderId,
    this.eventId,
    this.eventTitle,
    this.totalAmountRefunded,
    this.totalTicketsCancelled,
    this.stripeRefundId,
    this.cancelledAt,
  });

  factory CancelEventOrderData.fromRawJson(String str) =>
      CancelEventOrderData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancelEventOrderData.fromJson(Map<String, dynamic> json) =>
      CancelEventOrderData(
        orderId: json['orderId'] as String?,
        eventId: json['eventId'] as String?,
        eventTitle: json['eventTitle'] as String?,
        totalAmountRefunded: json['totalAmountRefunded'] as num?,
        totalTicketsCancelled: json['totalTicketsCancelled'] as int?,
        stripeRefundId: json['stripeRefundId'] as String?,
        cancelledAt: json['cancelledAt'] != null
            ? DateTime.tryParse(json['cancelledAt'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'eventId': eventId,
        'eventTitle': eventTitle,
        'totalAmountRefunded': totalAmountRefunded,
        'totalTicketsCancelled': totalTicketsCancelled,
        'stripeRefundId': stripeRefundId,
        'cancelledAt': cancelledAt?.toIso8601String(),
      };
}
