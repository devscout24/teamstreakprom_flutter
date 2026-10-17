import 'dart:convert';

class StaticContentModel {
  bool? success;
  int? statusCode;
  String? message;
  StaticContentMeta? meta;
  List<StaticContentItem>? data;

  StaticContentModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  factory StaticContentModel.fromRawJson(String str) =>
      StaticContentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StaticContentModel.fromJson(Map<String, dynamic> json) {
    List<StaticContentItem>? dataList;
    if (json['data'] != null && json['data'] is List) {
      dataList = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((x) => StaticContentItem.fromJson(x))
          .toList();
    }

    return StaticContentModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? StaticContentMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      data: dataList,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'meta': meta?.toJson(),
        'data': data?.map((x) => x.toJson()).toList(),
      };
}

typedef StaticContentResponseModel = StaticContentModel;

class StaticContentMeta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  StaticContentMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory StaticContentMeta.fromJson(Map<String, dynamic> json) =>
      StaticContentMeta(
        page: json['page'] as int?,
        limit: json['limit'] as int?,
        total: json['total'] as int?,
        totalPage: json['totalPage'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPage': totalPage,
      };
}

class StaticContentItem {
  String? id;
  String? title;
  String? slug;
  String? content;
  String? contentType;
  String? category;
  String? status;
  String? metaTitle;
  String? metaDescription;
  bool? isSystemPage;
  StaticContentUser? createdBy;
  StaticContentUser? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  StaticContentItem({
    this.id,
    this.title,
    this.slug,
    this.content,
    this.contentType,
    this.category,
    this.status,
    this.metaTitle,
    this.metaDescription,
    this.isSystemPage,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory StaticContentItem.fromJson(Map<String, dynamic> json) =>
      StaticContentItem(
        id: json['_id'] as String? ?? json['id'] as String?,
        title: json['title'] as String?,
        slug: json['slug'] as String?,
        content: json['content'] as String?,
        contentType: json['contentType'] as String?,
        category: json['category'] as String?,
        status: json['status'] as String?,
        metaTitle: json['metaTitle'] as String?,
        metaDescription: json['metaDescription'] as String?,
        isSystemPage: json['isSystemPage'] as bool?,
        createdBy: json['createdBy'] != null &&
                json['createdBy'] is Map<String, dynamic>
            ? StaticContentUser.fromJson(
                json['createdBy'] as Map<String, dynamic>)
            : null,
        updatedBy: json['updatedBy'] != null &&
                json['updatedBy'] is Map<String, dynamic>
            ? StaticContentUser.fromJson(
                json['updatedBy'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'slug': slug,
        'content': content,
        'contentType': contentType,
        'category': category,
        'status': status,
        'metaTitle': metaTitle,
        'metaDescription': metaDescription,
        'isSystemPage': isSystemPage,
        'createdBy': createdBy?.toJson(),
        'updatedBy': updatedBy?.toJson(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };
}

class StaticContentUser {
  String? id;
  String? name;
  String? email;
  String? role;

  StaticContentUser({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  factory StaticContentUser.fromJson(Map<String, dynamic> json) =>
      StaticContentUser(
        id: json['_id'] as String? ?? json['id'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        role: json['role'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'role': role,
      };
}
