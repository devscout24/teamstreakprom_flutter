class GetMarketplacesModel {
  bool? success;
  int? statusCode;
  String? message;
  MarketplaceMeta? meta;
  List<MarketplaceItem>? data;

  GetMarketplacesModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  factory GetMarketplacesModel.fromJson(Map<String, dynamic> json) {
    return GetMarketplacesModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? MarketplaceMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .map((e) => MarketplaceItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
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

class MarketplaceMeta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  MarketplaceMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory MarketplaceMeta.fromJson(Map<String, dynamic> json) {
    return MarketplaceMeta(
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

class MarketplaceItem {
  String? id;
  String? title;
  String? description;
  MarketplaceCategory? category;
  MarketplaceSubCategory? subCategory;
  String? location;
  num? latitude;
  num? longitude;
  DateTime? startDateTime;
  DateTime? endDateTime;
  int? points;
  int? quantity;
  List<String>? photos;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  MarketplaceItem({
    this.id,
    this.title,
    this.description,
    this.category,
    this.subCategory,
    this.location,
    this.latitude,
    this.longitude,
    this.startDateTime,
    this.endDateTime,
    this.points,
    this.quantity,
    this.photos,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? MarketplaceCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      subCategory:
          json['subCategory'] != null && json['subCategory'] is Map<String, dynamic>
              ? MarketplaceSubCategory.fromJson(
                  json['subCategory'] as Map<String, dynamic>)
              : null,
      location: json['location'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      startDateTime: json['startDateTime'] != null
          ? DateTime.tryParse(json['startDateTime'].toString())
          : null,
      endDateTime: json['endDateTime'] != null
          ? DateTime.tryParse(json['endDateTime'].toString())
          : null,
      points: json['points'] is num
          ? (json['points'] as num).toInt()
          : int.tryParse(json['points']?.toString() ?? ''),
      quantity: json['quantity'] is num
          ? (json['quantity'] as num).toInt()
          : int.tryParse(json['quantity']?.toString() ?? ''),
      photos: json['photos'] != null && json['photos'] is List
          ? (json['photos'] as List).map((e) => e.toString()).toList()
          : null,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category?.toJson(),
      'subCategory': subCategory?.toJson(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'points': points,
      'quantity': quantity,
      'photos': photos,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class MarketplaceCategory {
  String? id;
  String? name;
  String? description;

  MarketplaceCategory({
    this.id,
    this.name,
    this.description,
  });

  factory MarketplaceCategory.fromJson(Map<String, dynamic> json) {
    return MarketplaceCategory(
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

class MarketplaceSubCategory {
  String? id;
  String? name;
  String? description;

  MarketplaceSubCategory({
    this.id,
    this.name,
    this.description,
  });

  factory MarketplaceSubCategory.fromJson(Map<String, dynamic> json) {
    return MarketplaceSubCategory(
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
