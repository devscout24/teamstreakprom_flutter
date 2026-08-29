import 'dart:convert';

class HostEventDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  HostEventDetailsModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  HostEventDetailsModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    Data? data,
  }) => HostEventDetailsModel(
    success: success ?? this.success,
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory HostEventDetailsModel.fromRawJson(String str) =>
      HostEventDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HostEventDetailsModel.fromJson(Map<String, dynamic> json) =>
      HostEventDetailsModel(
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
    this.images,
    this.artistInfo,
    this.rewards,
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
    List<String>? images,
    List<ArtistInfo>? artistInfo,
    List<Reward>? rewards,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Data(
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

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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

  ArtistInfo({this.name, this.role, this.image});

  ArtistInfo copyWith({String? name, String? role, String? image}) =>
      ArtistInfo(
        name: name ?? this.name,
        role: role ?? this.role,
        image: image ?? this.image,
      );

  factory ArtistInfo.fromRawJson(String str) =>
      ArtistInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArtistInfo.fromJson(Map<String, dynamic> json) =>
      ArtistInfo(name: json["name"], role: json["role"], image: json["image"]);

  Map<String, dynamic> toJson() => {"name": name, "role": role, "image": image};
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
    id: json["_id"],
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

  HostId({this.id, this.name, this.email, this.role, this.profileImage});

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
    id: json["_id"],
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
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  Reward({
    this.title,
    this.description,
    this.pointsRequired,
    this.stock,
    this.images,
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
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Reward(
    title: title ?? this.title,
    description: description ?? this.description,
    pointsRequired: pointsRequired ?? this.pointsRequired,
    stock: stock ?? this.stock,
    images: images ?? this.images,
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Reward.fromRawJson(String str) => Reward.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    title: json["title"],
    description: json["description"],
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
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "pointsRequired": pointsRequired,
    "stock": stock,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
