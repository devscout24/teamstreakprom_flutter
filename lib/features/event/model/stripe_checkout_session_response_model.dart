class StripeCheckoutSessionResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  StripeCheckoutSessionData? data;

  StripeCheckoutSessionResponseModel(
      {this.success, this.statusCode, this.message, this.data});

  StripeCheckoutSessionResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null
        ? StripeCheckoutSessionData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StripeCheckoutSessionData {
  String? sessionId;
  String? url;

  StripeCheckoutSessionData({this.sessionId, this.url});

  StripeCheckoutSessionData.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionId'] = sessionId;
    data['url'] = url;
    return data;
  }
}
