import 'dart:convert';

class EventFetchByCategoryModel {
  bool? success;
  int? statusCode;
  String? message;
  Meta? meta;
  List<Datum>? data;

  EventFetchByCategoryModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  EventFetchByCategoryModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    Meta? meta,
    List<Datum>? data,
  }) => EventFetchByCategoryModel(
    success: success ?? this.success,
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    meta: meta ?? this.meta,
    data: data ?? this.data,
  );

  factory EventFetchByCategoryModel.fromRawJson(String str) =>
      EventFetchByCategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventFetchByCategoryModel.fromJson(Map<String, dynamic> json) =>
      EventFetchByCategoryModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "meta": meta?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  HostId? hostId;
  CategoryId? categoryId;
  String? title;
  double? latitude;
  double? longitude;
  int? ageRestriction;
  String? placeName;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  double? ticketPrice;
  int? stock;
  List<String>? images;
  List<ArtistInfo>? artistInfo;
  List<Reward>? rewards;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.hostId,
    this.categoryId,
    this.title,
    this.latitude,
    this.longitude,
    this.ageRestriction,
    this.placeName,
    this.description,
    this.startDate,
    this.endDate,
    this.ticketPrice,
    this.stock,
    this.images,
    this.artistInfo,
    this.rewards,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Datum copyWith({
    String? id,
    HostId? hostId,
    CategoryId? categoryId,
    String? title,
    double? latitude,
    double? longitude,
    int? ageRestriction,
    String? placeName,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? ticketPrice,
    int? stock,
    List<String>? images,
    List<ArtistInfo>? artistInfo,
    List<Reward>? rewards,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Datum(
    id: id ?? this.id,
    hostId: hostId ?? this.hostId,
    categoryId: categoryId ?? this.categoryId,
    title: title ?? this.title,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    ageRestriction: ageRestriction ?? this.ageRestriction,
    placeName: placeName ?? this.placeName,
    description: description ?? this.description,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    ticketPrice: ticketPrice ?? this.ticketPrice,
    stock: stock ?? this.stock,
    images: images ?? this.images,
    artistInfo: artistInfo ?? this.artistInfo,
    rewards: rewards ?? this.rewards,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    hostId: json["hostId"] == null ? null : HostId.fromJson(json["hostId"]),
    categoryId: json["categoryId"] == null
        ? null
        : CategoryId.fromJson(json["categoryId"]),
    title: json["title"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    ageRestriction: json["ageRestriction"],
    placeName: json["placeName"],
    description: json["description"],
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    ticketPrice: json["ticketPrice"]?.toDouble(),
    stock: json["stock"],
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"]!.map((x) => x)),
    artistInfo: json["artistInfo"] == null
        ? []
        : List<ArtistInfo>.from(
            json["artistInfo"]!.map((x) => ArtistInfo.fromJson(x)),
          ),
    rewards: json["rewards"] == null
        ? []
        : List<Reward>.from(json["rewards"]!.map((x) => Reward.fromJson(x))),
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
    "hostId": hostId?.toJson(),
    "categoryId": categoryId?.toJson(),
    "title": title,
    "latitude": latitude,
    "longitude": longitude,
    "ageRestriction": ageRestriction,
    "placeName": placeName,
    "description": description,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "ticketPrice": ticketPrice,
    "stock": stock,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "artistInfo": artistInfo == null
        ? []
        : List<dynamic>.from(artistInfo!.map((x) => x.toJson())),
    "rewards": rewards == null
        ? []
        : List<dynamic>.from(rewards!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class ArtistInfo {
  String? name;
  String? role;
  String? image;
  SocialMediaLinks? socialMediaLinks;

  ArtistInfo({this.name, this.role, this.image, this.socialMediaLinks});

  ArtistInfo copyWith({
    String? name,
    String? role,
    String? image,
    SocialMediaLinks? socialMediaLinks,
  }) => ArtistInfo(
    name: name ?? this.name,
    role: role ?? this.role,
    image: image ?? this.image,
    socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
  );

  factory ArtistInfo.fromRawJson(String str) =>
      ArtistInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArtistInfo.fromJson(Map<String, dynamic> json) => ArtistInfo(
    name: json["name"],
    role: json["role"],
    image: json["image"],
    socialMediaLinks: json["socialMediaLinks"] == null
        ? null
        : SocialMediaLinks.fromJson(json["socialMediaLinks"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "image": image,
    "socialMediaLinks": socialMediaLinks?.toJson(),
  };
}

class SocialMediaLinks {
  String? instagram;
  String? spotify;
  String? facebook;

  SocialMediaLinks({this.instagram, this.spotify, this.facebook});

  SocialMediaLinks copyWith({
    String? instagram,
    String? spotify,
    String? facebook,
  }) => SocialMediaLinks(
    instagram: instagram ?? this.instagram,
    spotify: spotify ?? this.spotify,
    facebook: facebook ?? this.facebook,
  );

  factory SocialMediaLinks.fromRawJson(String str) =>
      SocialMediaLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) =>
      SocialMediaLinks(
        instagram: json["instagram"],
        spotify: json["spotify"],
        facebook: json["facebook"],
      );

  Map<String, dynamic> toJson() => {
    "instagram": instagram,
    "spotify": spotify,
    "facebook": facebook,
  };
}

class CategoryId {
  Id? id;
  Name? name;
  CategoryIdDescription? description;

  CategoryId({this.id, this.name, this.description});

  CategoryId copyWith({
    Id? id,
    Name? name,
    CategoryIdDescription? description,
  }) => CategoryId(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
  );

  factory CategoryId.fromRawJson(String str) =>
      CategoryId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
    id: idValues.map[json["_id"]],
    name: nameValues.map[json["name"]],
    description: categoryIdDescriptionValues.map[json["description"]],
  );

  Map<String, dynamic> toJson() => {
    "_id": idValues.reverse[id],
    "name": nameValues.reverse[name],
    "description": categoryIdDescriptionValues.reverse[description],
  };
}

enum CategoryIdDescription { SPORTS_EVENTS_FITNESS_CLASSES_AND_COMPETITIONS }

final categoryIdDescriptionValues = EnumValues({
  "Sports events, fitness classes, and competitions":
      CategoryIdDescription.SPORTS_EVENTS_FITNESS_CLASSES_AND_COMPETITIONS,
});

enum Id {
  THE_6_A82_D3993_E6740_E8_C59124_BE,
  THE_6_A898345_B48_F1_D8_C03_F5617_A,
}

final idValues = EnumValues({
  "6a82d3993e6740e8c59124be": Id.THE_6_A82_D3993_E6740_E8_C59124_BE,
  "6a898345b48f1d8c03f5617a": Id.THE_6_A898345_B48_F1_D8_C03_F5617_A,
});

enum Name { SPORTS_FITNESS, SPORTS_FITNESS_SUB }

final nameValues = EnumValues({
  "Sports & Fitness": Name.SPORTS_FITNESS,
  "Sports & Fitness sub": Name.SPORTS_FITNESS_SUB,
});

class HostId {
  String? profileImage;
  String? id;
  String? name;
  String? email;
  Role? role;

  HostId({this.profileImage, this.id, this.name, this.email, this.role});

  HostId copyWith({
    String? profileImage,
    String? id,
    String? name,
    String? email,
    Role? role,
  }) => HostId(
    profileImage: profileImage ?? this.profileImage,
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
  );

  factory HostId.fromRawJson(String str) => HostId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostId.fromJson(Map<String, dynamic> json) => HostId(
    profileImage: json["profileImage"],
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    role: roleValues.map[json["role"]],
  );

  Map<String, dynamic> toJson() => {
    "profileImage": profileImage,
    "_id": id,
    "name": name,
    "email": email,
    "role": roleValues.reverse[role],
  };
}

enum Role { ADMIN, HOST, USER }

final roleValues = EnumValues({
  "ADMIN": Role.ADMIN,
  "HOST": Role.HOST,
  "USER": Role.USER,
});

class Reward {
  Title? title;
  RewardDescription? description;
  int? pointsRequired;
  int? stock;
  List<String>? images;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;

  Reward({
    this.title,
    this.description,
    this.pointsRequired,
    this.stock,
    this.images,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  Reward copyWith({
    Title? title,
    RewardDescription? description,
    int? pointsRequired,
    int? stock,
    List<String>? images,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? image,
  }) => Reward(
    title: title ?? this.title,
    description: description ?? this.description,
    pointsRequired: pointsRequired ?? this.pointsRequired,
    stock: stock ?? this.stock,
    images: images ?? this.images,
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    image: image ?? this.image,
  );

  factory Reward.fromRawJson(String str) => Reward.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    title: titleValues.map[json["title"]],
    description: rewardDescriptionValues.map[json["description"]],
    pointsRequired: json["pointsRequired"],
    stock: json["stock"],
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"]!.map((x) => x)),
    id: json["_id"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "title": titleValues.reverse[title],
    "description": rewardDescriptionValues.reverse[description],
    "pointsRequired": pointsRequired,
    "stock": stock,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "image": image,
  };
}

enum RewardDescription { FREE_VIP_AREA_ACCESS_BADGE, RE_DES, SDF }

final rewardDescriptionValues = EnumValues({
  "Free VIP area access badge": RewardDescription.FREE_VIP_AREA_ACCESS_BADGE,
  "Re des": RewardDescription.RE_DES,
  "sdf": RewardDescription.SDF,
});

enum Title { ASDF, RE_TITLE, VIP_PASS_BADGE }

final titleValues = EnumValues({
  "asdf": Title.ASDF,
  "Re title": Title.RE_TITLE,
  "VIP Pass Badge": Title.VIP_PASS_BADGE,
});

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  Meta copyWith({int? page, int? limit, int? total, int? totalPage}) => Meta(
    page: page ?? this.page,
    limit: limit ?? this.limit,
    total: total ?? this.total,
    totalPage: totalPage ?? this.totalPage,
  );

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPage": totalPage,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
