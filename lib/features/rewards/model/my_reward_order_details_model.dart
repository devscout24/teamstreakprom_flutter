import 'dart:convert';

class MyRewardOrderDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  RewardOrderDetailsData? data;

  MyRewardOrderDetailsModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MyRewardOrderDetailsModel.fromRawJson(String str) =>
      MyRewardOrderDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyRewardOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return MyRewardOrderDetailsModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? RewardOrderDetailsData.fromJson(
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

class RewardOrderDetailsData {
  String? id;
  RewardOrderUser? user;
  String? itemType;
  RewardOrderBusinessOwner? businessOwnerId;
  RewardOrderItemDetails? itemId;
  RewardOrderItemDetails? item;
  num? itemPoints;
  int? quantity;
  String? status;
  String? qrCode;
  DateTime? createdAt;
  DateTime? updatedAt;

  RewardOrderDetailsData({
    this.id,
    this.user,
    this.itemType,
    this.businessOwnerId,
    this.itemId,
    this.item,
    this.itemPoints,
    this.quantity,
    this.status,
    this.qrCode,
    this.createdAt,
    this.updatedAt,
  });

  factory RewardOrderDetailsData.fromJson(Map<String, dynamic> json) {
    return RewardOrderDetailsData(
      id: (json['_id'] ?? json['id']) as String?,
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? RewardOrderUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      itemType: json['itemType'] as String?,
      businessOwnerId: json['businessOwnerId'] != null &&
              json['businessOwnerId'] is Map<String, dynamic>
          ? RewardOrderBusinessOwner.fromJson(
              json['businessOwnerId'] as Map<String, dynamic>)
          : null,
      itemId: json['itemId'] != null && json['itemId'] is Map<String, dynamic>
          ? RewardOrderItemDetails.fromJson(
              json['itemId'] as Map<String, dynamic>)
          : null,
      item: json['item'] != null && json['item'] is Map<String, dynamic>
          ? RewardOrderItemDetails.fromJson(
              json['item'] as Map<String, dynamic>)
          : null,
      itemPoints: json['itemPoints'] as num?,
      quantity: json['quantity'] as int?,
      status: json['status'] as String?,
      qrCode: json['qrCode'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'user': user?.toJson(),
      'itemType': itemType,
      'businessOwnerId': businessOwnerId?.toJson(),
      'itemId': itemId?.toJson(),
      'item': item?.toJson(),
      'itemPoints': itemPoints,
      'quantity': quantity,
      'status': status,
      'qrCode': qrCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class RewardOrderUser {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? role;

  RewardOrderUser({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.role,
  });

  factory RewardOrderUser.fromJson(Map<String, dynamic> json) {
    return RewardOrderUser(
      id: (json['_id'] ?? json['id']) as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'role': role,
    };
  }
}

class RewardOrderBusinessOwner {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? role;

  RewardOrderBusinessOwner({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.role,
  });

  factory RewardOrderBusinessOwner.fromJson(Map<String, dynamic> json) {
    return RewardOrderBusinessOwner(
      id: (json['_id'] ?? json['id']) as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'role': role,
    };
  }
}

class RewardOrderItemDetails {
  String? id;
  String? businessOwnerId;
  String? title;
  String? description;
  String? category;
  String? location;
  double? latitude;
  double? longitude;
  DateTime? startDateTime;
  DateTime? endDateTime;
  num? points;
  int? quantity;
  int? claimQuantity;
  List<String>? photos;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  RewardOrderItemDetails({
    this.id,
    this.businessOwnerId,
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
    this.claimQuantity,
    this.photos,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory RewardOrderItemDetails.fromJson(Map<String, dynamic> json) {
    return RewardOrderItemDetails(
      id: (json['_id'] ?? json['id']) as String?,
      businessOwnerId: json['businessOwnerId']?.toString(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] is Map
          ? (json['category']['name'] ?? json['category']['_id'])?.toString()
          : json['category']?.toString(),
      location: json['location'] as String?,
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      startDateTime: json['startDateTime'] != null
          ? DateTime.tryParse(json['startDateTime'].toString())
          : null,
      endDateTime: json['endDateTime'] != null
          ? DateTime.tryParse(json['endDateTime'].toString())
          : null,
      points: json['points'] as num?,
      quantity: json['quantity'] as int?,
      claimQuantity: json['claimQuantity'] as int?,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'businessOwnerId': businessOwnerId,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'points': points,
      'quantity': quantity,
      'claimQuantity': claimQuantity,
      'photos': photos,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
