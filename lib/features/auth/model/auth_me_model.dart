import 'dart:convert';

class AuthMeModel {
  bool? success;
  int? statusCode;
  Data? data;

  AuthMeModel({
    this.success,
    this.statusCode,
    this.data,
  });

  AuthMeModel copyWith({
    bool? success,
    int? statusCode,
    Data? data,
  }) => AuthMeModel(
    success: success ?? this.success,
    statusCode: statusCode ?? this.statusCode,
    data: data ?? this.data,
  );

  factory AuthMeModel.fromRawJson(String str) => AuthMeModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory AuthMeModel.fromJson(Map<String, dynamic> json) => AuthMeModel(
    success: json["success"],
    statusCode: json["statusCode"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "data": data?.toJson(),
  };
}

class Data {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? role;
  int? totalPoints;
  int? walletBalance;
  String? refreshToken;
  bool? isAgeOver18;
  bool? agreesToTerms;
  bool? isActive;
  bool? isSuspend;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.role,
    this.totalPoints,
    this.walletBalance,
    this.refreshToken,
    this.isAgeOver18,
    this.agreesToTerms,
    this.isActive,
    this.isSuspend,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImage,
    String? role,
    int? totalPoints,
    int? walletBalance,
    String? refreshToken,
    bool? isAgeOver18,
    bool? agreesToTerms,
    bool? isActive,
    bool? isSuspend,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Data(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    profileImage: profileImage ?? this.profileImage,
    role: role ?? this.role,
    totalPoints: totalPoints ?? this.totalPoints,
    walletBalance: walletBalance ?? this.walletBalance,
    refreshToken: refreshToken ?? this.refreshToken,
    isAgeOver18: isAgeOver18 ?? this.isAgeOver18,
    agreesToTerms: agreesToTerms ?? this.agreesToTerms,
    isActive: isActive ?? this.isActive,
    isSuspend: isSuspend ?? this.isSuspend,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    profileImage: json["profileImage"],
    role: json["role"],
    totalPoints: json["totalPoints"],
    walletBalance: json["walletBalance"],
    refreshToken: json["refreshToken"],
    isAgeOver18: json["isAgeOver18"],
    agreesToTerms: json["agreesToTerms"],
    isActive: json["isActive"],
    isSuspend: json["isSuspend"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "profileImage": profileImage,
    "role": role,
    "totalPoints": totalPoints,
    "walletBalance": walletBalance,
    "refreshToken": refreshToken,
    "isAgeOver18": isAgeOver18,
    "agreesToTerms": agreesToTerms,
    "isActive": isActive,
    "isSuspend": isSuspend,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
