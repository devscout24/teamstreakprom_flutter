class MarketplaceResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MarketplaceData? data;

  MarketplaceResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MarketplaceResponseModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceResponseModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? MarketplaceData.fromJson(json['data'] as Map<String, dynamic>)
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

class MarketplaceData {
  final String? id;
  final String? title;
  final String? description;
  final MarketplaceCategory? category;
  final String? location;
  final num? latitude;
  final num? longitude;
  final String? startDateTime;
  final String? endDateTime;
  final int? points;
  final int? quantity;
  final List<String>? photos;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  MarketplaceData({
    this.id,
    this.title,
    this.description,
    this.category,
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

  factory MarketplaceData.fromJson(Map<String, dynamic> json) {
    return MarketplaceData(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? MarketplaceCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      location: json['location'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      startDateTime: json['startDateTime'] as String?,
      endDateTime: json['endDateTime'] as String?,
      points: json['points'] as int?,
      quantity: json['quantity'] as int?,
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category?.toJson(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'points': points,
      'quantity': quantity,
      'photos': photos,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class MarketplaceCategory {
  final String? id;
  final String? name;
  final String? description;

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
