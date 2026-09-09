class GetMarketplaceDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  MarketplaceDetailsData? data;

  GetMarketplaceDetailsModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetMarketplaceDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetMarketplaceDetailsModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? MarketplaceDetailsData.fromJson(
              json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class MarketplaceDetailsData {
  String? id;
  String? title;
  String? description;
  MarketplaceCategoryItem? category;
  MarketplaceSubCategoryItem? subCategory;
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

  MarketplaceDetailsData({
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

  factory MarketplaceDetailsData.fromJson(Map<String, dynamic> json) {
    return MarketplaceDetailsData(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? MarketplaceCategoryItem.fromJson(
              json['category'] as Map<String, dynamic>)
          : null,
      subCategory: json['subCategory'] != null &&
              json['subCategory'] is Map<String, dynamic>
          ? MarketplaceSubCategoryItem.fromJson(
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

class MarketplaceCategoryItem {
  String? id;
  String? name;
  String? description;

  MarketplaceCategoryItem({
    this.id,
    this.name,
    this.description,
  });

  factory MarketplaceCategoryItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceCategoryItem(
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

class MarketplaceSubCategoryItem {
  String? id;
  String? name;
  String? description;

  MarketplaceSubCategoryItem({
    this.id,
    this.name,
    this.description,
  });

  factory MarketplaceSubCategoryItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceSubCategoryItem(
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
