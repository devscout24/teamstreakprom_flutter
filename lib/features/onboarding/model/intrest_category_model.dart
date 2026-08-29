import 'dart:convert';

class IntrestCategoryModel {
  bool? success;
  int? statusCode;
  String? message;
  Meta? meta;
  List<Datum>? data;

  IntrestCategoryModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  IntrestCategoryModel copyWith({
    bool? success,
    int? statusCode,
    String? message,
    Meta? meta,
    List<Datum>? data,
  }) => IntrestCategoryModel(
    success: success ?? this.success,
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    meta: meta ?? this.meta,
    data: data ?? this.data,
  );

  factory IntrestCategoryModel.fromRawJson(String str) =>
      IntrestCategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IntrestCategoryModel.fromJson(Map<String, dynamic> json) =>
      IntrestCategoryModel(
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
  String? name;
  String? description;
  ParentCategory? parentCategory;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.name,
    this.description,
    this.parentCategory,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Datum copyWith({
    String? id,
    String? name,
    String? description,
    ParentCategory? parentCategory,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Datum(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    parentCategory: parentCategory ?? this.parentCategory,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    parentCategory: json["parentCategory"] == null
        ? null
        : ParentCategory.fromJson(json["parentCategory"]),
    isActive: json["isActive"],
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
    "name": name,
    "description": description,
    "parentCategory": parentCategory?.toJson(),
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class ParentCategory {
  String? id;
  String? name;
  String? description;

  ParentCategory({this.id, this.name, this.description});

  ParentCategory copyWith({String? id, String? name, String? description}) =>
      ParentCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  factory ParentCategory.fromRawJson(String str) =>
      ParentCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParentCategory.fromJson(Map<String, dynamic> json) => ParentCategory(
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
