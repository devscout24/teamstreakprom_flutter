import 'get_marketplace_details_model.dart';

class MyMarketplacesResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MyMarketplacesMeta? meta;
  final List<MyMarketplaceData>? data;

  MyMarketplacesResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  factory MyMarketplacesResponseModel.fromJson(Map<String, dynamic> json) {
    return MyMarketplacesResponseModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? MyMarketplacesMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MyMarketplaceData.fromJson(e as Map<String, dynamic>))
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

class MyMarketplacesMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  MyMarketplacesMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory MyMarketplacesMeta.fromJson(Map<String, dynamic> json) {
    return MyMarketplacesMeta(
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

class MyMarketplaceData {
  final String? id;
  final String? title;
  final String? description;
  final MyMarketplaceCategory? category;
  final MyMarketplaceSubCategory? subCategory;
  final String? location;
  final num? latitude;
  final num? longitude;
  final String? startDateTime;
  final String? endDateTime;
  final int? points;
  final int? quantity;
  final int? claimQuantity;
  final List<String>? photos;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final MyMarketplaceBusinessProfile? businessProfile;

  MyMarketplaceData({
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
    this.claimQuantity,
    this.photos,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.businessProfile,
  });

  factory MyMarketplaceData.fromJson(Map<String, dynamic> json) {
    return MyMarketplaceData(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? MyMarketplaceCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      subCategory: json['subCategory'] != null && json['subCategory'] is Map<String, dynamic>
          ? MyMarketplaceSubCategory.fromJson(json['subCategory'] as Map<String, dynamic>)
          : null,
      location: json['location'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      startDateTime: json['startDateTime'] as String?,
      endDateTime: json['endDateTime'] as String?,
      points: json['points'] as int?,
      quantity: json['quantity'] as int?,
      claimQuantity: json['claimQuantity'] as int?,
      photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      businessProfile: json['businessProfile'] != null && json['businessProfile'] is Map<String, dynamic>
          ? MyMarketplaceBusinessProfile.fromJson(json['businessProfile'] as Map<String, dynamic>)
          : null,
    );
  }

  MarketplaceDetailsData toMarketplaceDetailsData() {
    return MarketplaceDetailsData(
      id: id,
      title: title,
      description: description,
      category: category != null
          ? MarketplaceCategoryItem(
              id: category!.id,
              name: category!.name,
            )
          : null,
      subCategory: subCategory != null
          ? MarketplaceSubCategoryItem(
              id: subCategory!.id,
              name: subCategory!.name,
            )
          : null,
      location: location,
      latitude: latitude,
      longitude: longitude,
      startDateTime:
          startDateTime != null ? DateTime.tryParse(startDateTime!) : null,
      endDateTime:
          endDateTime != null ? DateTime.tryParse(endDateTime!) : null,
      points: points,
      quantity: quantity,
      claimQuantity: claimQuantity,
      photos: photos,
      isActive: isActive,
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
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'points': points,
      'quantity': quantity,
      'claimQuantity': claimQuantity,
      'photos': photos,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'businessProfile': businessProfile?.toJson(),
    };
  }
}

class MyMarketplaceCategory {
  final String? id;
  final String? name;
  final String? description;

  MyMarketplaceCategory({
    this.id,
    this.name,
    this.description,
  });

  factory MyMarketplaceCategory.fromJson(Map<String, dynamic> json) {
    return MyMarketplaceCategory(
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

class MyMarketplaceSubCategory {
  final String? id;
  final String? name;
  final String? description;

  MyMarketplaceSubCategory({
    this.id,
    this.name,
    this.description,
  });

  factory MyMarketplaceSubCategory.fromJson(Map<String, dynamic> json) {
    return MyMarketplaceSubCategory(
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

class MyMarketplaceBusinessProfile {
  final int? rating;
  final int? sold;
  final String? businessName;
  final String? businessDescription;
  final String? location;
  final String? profileImage;

  MyMarketplaceBusinessProfile({
    this.rating,
    this.sold,
    this.businessName,
    this.businessDescription,
    this.location,
    this.profileImage,
  });

  factory MyMarketplaceBusinessProfile.fromJson(Map<String, dynamic> json) {
    return MyMarketplaceBusinessProfile(
      rating: json['rating'] as int?,
      sold: json['sold'] as int?,
      businessName: json['businessName'] as String?,
      businessDescription: json['businessDescription'] as String?,
      location: json['location'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'sold': sold,
      'businessName': businessName,
      'businessDescription': businessDescription,
      'location': location,
      'profileImage': profileImage,
    };
  }
}
