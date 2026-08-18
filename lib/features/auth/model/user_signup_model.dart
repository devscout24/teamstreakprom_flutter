import 'dart:convert';

class UserSignupModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  UserSignupModel({this.success, this.statusCode, this.message, this.data});

  UserSignupModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    Data? data,
  }) => UserSignupModel(
    success: success ?? this.success,
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory UserSignupModel.fromRawJson(String str) =>
      UserSignupModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserSignupModel.fromJson(Map<String, dynamic> json) =>
      UserSignupModel(
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
  String? id;
  String? name;
  String? email;
  String? role;
  String? accessToken;
  String? refreshToken;
  dynamic businessProfile;

  Data({
    this.id,
    this.name,
    this.email,
    this.role,
    this.accessToken,
    this.refreshToken,
    this.businessProfile,
  });

  Data copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? accessToken,
    String? refreshToken,
    dynamic businessProfile,
  }) => Data(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    businessProfile: businessProfile ?? this.businessProfile,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    businessProfile: json["businessProfile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "role": role,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "businessProfile": businessProfile,
  };
}
