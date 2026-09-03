import 'dart:convert';

class UserProfileModel {
  bool? success;
  int? statusCode;
  String? message;
  Meta? meta;
  Data? data;

  UserProfileModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  UserProfileModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    Meta? meta,
    Data? data,
  }) =>
      UserProfileModel(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        meta: meta ?? this.meta,
        data: data ?? this.data,
      );

  factory UserProfileModel.fromRawJson(String str) =>
      UserProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "meta": meta?.toJson(),
    "data": data?.toJson(),
  };
}

class Meta {
  int? totalEvents;
  int? totalRating;
  int? totalRevenue;

  Meta({
    this.totalEvents,
    this.totalRating,
    this.totalRevenue,
  });

  Meta copyWith({
    int? totalEvents,
    int? totalRating,
    int? totalRevenue,
  }) =>
      Meta(
        totalEvents: totalEvents ?? this.totalEvents,
        totalRating: totalRating ?? this.totalRating,
        totalRevenue: totalRevenue ?? this.totalRevenue,
      );

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalEvents: json["totalEvents"],
        totalRating: json["totalRating"],
        totalRevenue: json["totalRevenue"],
      );

  Map<String, dynamic> toJson() => {
    "totalEvents": totalEvents,
    "totalRating": totalRating,
    "totalRevenue": totalRevenue,
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
  BusinessProfile? businessProfile;

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
    this.businessProfile,
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
    BusinessProfile? businessProfile,
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
    businessProfile: businessProfile ?? this.businessProfile,
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
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    businessProfile: json["businessProfile"] == null
        ? null
        : BusinessProfile.fromJson(json["businessProfile"]),
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
    "businessProfile": businessProfile?.toJson(),
  };
}

class BusinessProfile {
  String? id;
  String? userId;
  String? businessName;
  String? businessDescription;
  String? einNumber;
  String? location;
  String? govtIdFrontImage;
  String? govtIdBackImage;
  String? businessLicenseFrontImage;
  String? businessLicenseBackImage;
  String? verificationStatus;
  DateTime? submittedAt;
  dynamic verifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  BusinessProfile({
    this.id,
    this.userId,
    this.businessName,
    this.businessDescription,
    this.einNumber,
    this.location,
    this.govtIdFrontImage,
    this.govtIdBackImage,
    this.businessLicenseFrontImage,
    this.businessLicenseBackImage,
    this.verificationStatus,
    this.submittedAt,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  BusinessProfile copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? businessDescription,
    String? einNumber,
    String? location,
    String? govtIdFrontImage,
    String? govtIdBackImage,
    String? businessLicenseFrontImage,
    String? businessLicenseBackImage,
    String? verificationStatus,
    DateTime? submittedAt,
    dynamic verifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => BusinessProfile(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    businessName: businessName ?? this.businessName,
    businessDescription: businessDescription ?? this.businessDescription,
    einNumber: einNumber ?? this.einNumber,
    location: location ?? this.location,
    govtIdFrontImage: govtIdFrontImage ?? this.govtIdFrontImage,
    govtIdBackImage: govtIdBackImage ?? this.govtIdBackImage,
    businessLicenseFrontImage:
        businessLicenseFrontImage ?? this.businessLicenseFrontImage,
    businessLicenseBackImage:
        businessLicenseBackImage ?? this.businessLicenseBackImage,
    verificationStatus: verificationStatus ?? this.verificationStatus,
    submittedAt: submittedAt ?? this.submittedAt,
    verifiedAt: verifiedAt ?? this.verifiedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory BusinessProfile.fromRawJson(String str) =>
      BusinessProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      BusinessProfile(
        id: json["_id"],
        userId: json["userId"],
        businessName: json["businessName"],
        businessDescription: json["businessDescription"],
        einNumber: json["einNumber"],
        location: json["location"],
        govtIdFrontImage: json["govtIdFrontImage"],
        govtIdBackImage: json["govtIdBackImage"],
        businessLicenseFrontImage: json["businessLicenseFrontImage"],
        businessLicenseBackImage: json["businessLicenseBackImage"],
        verificationStatus: json["verificationStatus"],
        submittedAt: json["submittedAt"] == null
            ? null
            : DateTime.parse(json["submittedAt"]),
        verifiedAt: json["verifiedAt"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "businessName": businessName,
    "businessDescription": businessDescription,
    "einNumber": einNumber,
    "location": location,
    "govtIdFrontImage": govtIdFrontImage,
    "govtIdBackImage": govtIdBackImage,
    "businessLicenseFrontImage": businessLicenseFrontImage,
    "businessLicenseBackImage": businessLicenseBackImage,
    "verificationStatus": verificationStatus,
    "submittedAt": submittedAt?.toIso8601String(),
    "verifiedAt": verifiedAt,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
