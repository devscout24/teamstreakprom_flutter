class DeleteEventResponseModel {
  bool? success;
  int? statusCode;
  String? message;

  DeleteEventResponseModel({this.success, this.statusCode, this.message});

  DeleteEventResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}
