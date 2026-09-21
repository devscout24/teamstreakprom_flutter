import 'dart:convert';

class HostEventDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  Meta? meta;
  List<Data>? data;

  HostEventDetailsModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  Data? get singleData =>
      (data != null && data!.isNotEmpty) ? data!.first : null;

  HostEventDetailsModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    Meta? meta,
    List<Data>? data,
  }) =>
      HostEventDetailsModel(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        meta: meta ?? this.meta,
        data: data ?? this.data,
      );

  factory HostEventDetailsModel.fromRawJson(String str) =>
      HostEventDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostEventDetailsModel.fromJson(Map<String, dynamic> json) {
    List<Data>? dataList;
    if (json["data"] != null) {
      if (json["data"] is List) {
        dataList = List<Data>.from(
          (json["data"] as List)
              .whereType<Map<String, dynamic>>()
              .map((x) => Data.fromJson(x)),
        );
      } else if (json["data"] is Map<String, dynamic>) {
        dataList = [Data.fromJson(json["data"])];
      }
    }

    return HostEventDetailsModel(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: dataList,
    );
  }

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

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

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

class Data {
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
  List<PriceCategory>? priceCategories;
  List<String>? images;
  List<ArtistInfo>? artistInfo;
  List<Reward>? rewards;
  String? payoutStatus;
  double? payoutAmount;
  double? platformFeeAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
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
    this.priceCategories,
    this.images,
    this.artistInfo,
    this.rewards,
    this.payoutStatus,
    this.payoutAmount,
    this.platformFeeAmount,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data copyWith({
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
    List<PriceCategory>? priceCategories,
    List<String>? images,
    List<ArtistInfo>? artistInfo,
    List<Reward>? rewards,
    String? payoutStatus,
    double? payoutAmount,
    double? platformFeeAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      Data(
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
        priceCategories: priceCategories ?? this.priceCategories,
        images: images ?? this.images,
        artistInfo: artistInfo ?? this.artistInfo,
        rewards: rewards ?? this.rewards,
        payoutStatus: payoutStatus ?? this.payoutStatus,
        payoutAmount: payoutAmount ?? this.payoutAmount,
        platformFeeAmount: platformFeeAmount ?? this.platformFeeAmount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"] ?? json["id"],
        hostId:
            json["hostId"] == null ? null : HostId.fromJson(json["hostId"]),
        categoryId: json["categoryId"] == null
            ? null
            : CategoryId.fromJson(json["categoryId"]),
        title: json["title"],
        latitude: json["latitude"] != null
            ? (json["latitude"] as num).toDouble()
            : null,
        longitude: json["longitude"] != null
            ? (json["longitude"] as num).toDouble()
            : null,
        ageRestriction: json["ageRestriction"],
        placeName: json["placeName"],
        description: json["description"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.tryParse(json["startDate"]),
        endDate: json["endDate"] == null
            ? null
            : DateTime.tryParse(json["endDate"]),
        ticketPrice: json["ticketPrice"] != null
            ? (json["ticketPrice"] as num).toDouble()
            : null,
        stock: json["stock"],
        priceCategories: json["priceCategories"] == null
            ? []
            : List<PriceCategory>.from(
                (json["priceCategories"] as List)
                    .whereType<Map<String, dynamic>>()
                    .map((x) => PriceCategory.fromJson(x)),
              ),
        images: json["images"] == null
            ? []
            : List<String>.from(
                (json["images"] as List)
                    .map((x) => x?.toString() ?? '')
                    .where((x) => x.isNotEmpty),
              ),
        artistInfo: json["artistInfo"] == null
            ? []
            : List<ArtistInfo>.from(
                (json["artistInfo"] as List)
                    .whereType<Map<String, dynamic>>()
                    .map((x) => ArtistInfo.fromJson(x)),
              ),
        rewards: json["rewards"] == null
            ? []
            : List<Reward>.from(
                (json["rewards"] as List)
                    .whereType<Map<String, dynamic>>()
                    .map((x) => Reward.fromJson(x)),
              ),
        payoutStatus: json["payoutStatus"],
        payoutAmount: json["payoutAmount"] != null
            ? (json["payoutAmount"] as num).toDouble()
            : null,
        platformFeeAmount: json["platformFeeAmount"] != null
            ? (json["platformFeeAmount"] as num).toDouble()
            : null,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
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
        "priceCategories": priceCategories == null
            ? []
            : List<dynamic>.from(priceCategories!.map((x) => x.toJson())),
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "artistInfo": artistInfo == null
            ? []
            : List<dynamic>.from(artistInfo!.map((x) => x.toJson())),
        "rewards": rewards == null
            ? []
            : List<dynamic>.from(rewards!.map((x) => x.toJson())),
        "payoutStatus": payoutStatus,
        "payoutAmount": payoutAmount,
        "platformFeeAmount": platformFeeAmount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class PriceCategory {
  String? id;
  String? name;
  double? price;
  int? stock;
  DateTime? createdAt;
  DateTime? updatedAt;

  PriceCategory({
    this.id,
    this.name,
    this.price,
    this.stock,
    this.createdAt,
    this.updatedAt,
  });

  PriceCategory copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PriceCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        stock: stock ?? this.stock,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PriceCategory.fromRawJson(String str) =>
      PriceCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PriceCategory.fromJson(Map<String, dynamic> json) => PriceCategory(
        id: json["_id"] ?? json["id"],
        name: json["name"],
        price: json["price"] != null ? (json["price"] as num).toDouble() : null,
        stock: json["stock"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class ArtistInfo {
  String? name;
  String? role;
  String? image;
  SocialMediaLinks? socialMediaLinks;

  ArtistInfo({
    this.name,
    this.role,
    this.image,
    this.socialMediaLinks,
  });

  ArtistInfo copyWith({
    String? name,
    String? role,
    String? image,
    SocialMediaLinks? socialMediaLinks,
  }) =>
      ArtistInfo(
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
  Map<String, dynamic>? other;

  SocialMediaLinks({
    this.instagram,
    this.spotify,
    this.other,
  });

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) =>
      SocialMediaLinks(
        instagram: json["instagram"],
        spotify: json["spotify"] ?? json["spotfy.com/ify"],
        other: json,
      );

  Map<String, dynamic> toJson() => {
        if (instagram != null) "instagram": instagram,
        if (spotify != null) "spotify": spotify,
      };
}

class CategoryId {
  String? id;
  String? name;
  String? description;

  CategoryId({this.id, this.name, this.description});

  CategoryId copyWith({String? id, String? name, String? description}) =>
      CategoryId(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  factory CategoryId.fromRawJson(String str) =>
      CategoryId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json["_id"] ?? json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
      };
}

class HostId {
  String? id;
  String? name;
  String? email;
  String? role;
  String? profileImage;

  HostId({
    this.id,
    this.name,
    this.email,
    this.role,
    this.profileImage,
  });

  HostId copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? profileImage,
  }) =>
      HostId(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        profileImage: profileImage ?? this.profileImage,
      );

  factory HostId.fromRawJson(String str) => HostId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostId.fromJson(Map<String, dynamic> json) => HostId(
        id: json["_id"] ?? json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "role": role,
        "profileImage": profileImage,
      };
}

class Reward {
  String? title;
  String? description;
  int? pointsRequired;
  int? stock;
  List<String>? images;
  String? image;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  Reward({
    this.title,
    this.description,
    this.pointsRequired,
    this.stock,
    this.images,
    this.image,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  Reward copyWith({
    String? title,
    String? description,
    int? pointsRequired,
    int? stock,
    List<String>? images,
    String? image,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Reward(
        title: title ?? this.title,
        description: description ?? this.description,
        pointsRequired: pointsRequired ?? this.pointsRequired,
        stock: stock ?? this.stock,
        images: images ?? this.images,
        image: image ?? this.image,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Reward.fromRawJson(String str) => Reward.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reward.fromJson(Map<String, dynamic> json) {
    List<String> imgs = [];
    if (json["images"] != null && json["images"] is List) {
      imgs = List<String>.from(
        (json["images"] as List)
            .map((x) => x?.toString() ?? '')
            .where((x) => x.isNotEmpty),
      );
    }
    if (imgs.isEmpty && json["image"] != null && json["image"].toString().isNotEmpty) {
      imgs.add(json["image"].toString());
    }

    return Reward(
      title: json["title"],
      description: json["description"],
      pointsRequired: json["pointsRequired"],
      stock: json["stock"],
      images: imgs,
      image: json["image"],
      id: json["_id"] ?? json["id"],
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.tryParse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
          ? null
          : DateTime.tryParse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "pointsRequired": pointsRequired,
        "stock": stock,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "image": image,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
