class StripeAccountStatusModel {
  bool? success;
  int? statusCode;
  String? message;
  StripeAccountStatusData? data;

  StripeAccountStatusModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  StripeAccountStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null
        ? StripeAccountStatusData.fromJson(json['data'])
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

class StripeAccountStatusData {
  String? stripeAccountId;
  bool? isStripeConnected;
  bool? isStripeVerified;
  String? stripeAccountStatus;
  bool? stripePayoutsEnabled;
  bool? stripeChargesEnabled;
  bool? stripeDetailsSubmitted;

  StripeAccountStatusData({
    this.stripeAccountId,
    this.isStripeConnected,
    this.isStripeVerified,
    this.stripeAccountStatus,
    this.stripePayoutsEnabled,
    this.stripeChargesEnabled,
    this.stripeDetailsSubmitted,
  });

  StripeAccountStatusData.fromJson(Map<String, dynamic> json) {
    stripeAccountId = json['stripeAccountId'];
    isStripeConnected = json['isStripeConnected'];
    isStripeVerified = json['isStripeVerified'];
    stripeAccountStatus = json['stripeAccountStatus'];
    stripePayoutsEnabled = json['stripePayoutsEnabled'];
    stripeChargesEnabled = json['stripeChargesEnabled'];
    stripeDetailsSubmitted = json['stripeDetailsSubmitted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stripeAccountId'] = stripeAccountId;
    data['isStripeConnected'] = isStripeConnected;
    data['isStripeVerified'] = isStripeVerified;
    data['stripeAccountStatus'] = stripeAccountStatus;
    data['stripePayoutsEnabled'] = stripePayoutsEnabled;
    data['stripeChargesEnabled'] = stripeChargesEnabled;
    data['stripeDetailsSubmitted'] = stripeDetailsSubmitted;
    return data;
  }
}
