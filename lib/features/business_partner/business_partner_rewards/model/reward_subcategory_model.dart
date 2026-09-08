class RewardSubcategoryResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final Meta? meta;
  final List<RewardSubcategoryModel>? data;

  RewardSubcategoryResponse({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  factory RewardSubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return RewardSubcategoryResponse(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: (json['data'] as List?)
          ?.map((e) => RewardSubcategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}

class RewardSubcategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final RewardCategoryRef? rewardCategory;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  RewardSubcategoryModel({
    this.id,
    this.name,
    this.description,
    this.rewardCategory,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RewardSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return RewardSubcategoryModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      rewardCategory: json['rewardCategory'] != null
          ? RewardCategoryRef.fromJson(json['rewardCategory'])
          : null,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'rewardCategory': rewardCategory?.toJson(),
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class RewardCategoryRef {
  final String? id;
  final String? name;
  final String? description;

  RewardCategoryRef({
    this.id,
    this.name,
    this.description,
  });

  factory RewardCategoryRef.fromJson(Map<String, dynamic> json) {
    return RewardCategoryRef(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
    };
  }
}
