class MyRewardOrdersResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  RewardOrdersMeta? meta;
  List<RewardOrderItem>? data;

  MyRewardOrdersResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  factory MyRewardOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return MyRewardOrdersResponseModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? RewardOrdersMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .map((e) => RewardOrderItem.fromJson(e as Map<String, dynamic>))
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

class RewardOrdersMeta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  RewardOrdersMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory RewardOrdersMeta.fromJson(Map<String, dynamic> json) {
    return RewardOrdersMeta(
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

class RewardOrderItem {
  String? id;
  String? itemType;
  String? title;
  List<String>? photos;
  String? description;
  String? location;
  int? points;
  int? quantity;
  String? status;
  String? qrCode;
  DateTime? createdAt;
  DateTime? updatedAt;

  RewardOrderItem({
    this.id,
    this.itemType,
    this.title,
    this.photos,
    this.description,
    this.location,
    this.points,
    this.quantity,
    this.status,
    this.qrCode,
    this.createdAt,
    this.updatedAt,
  });

  factory RewardOrderItem.fromJson(Map<String, dynamic> json) {
    return RewardOrderItem(
      id: json['_id'] as String?,
      itemType: json['itemType'] as String?,
      title: json['title'] as String?,
      photos: json['photos'] != null && json['photos'] is List
          ? (json['photos'] as List).map((e) => e.toString()).toList()
          : null,
      description: json['description'] as String?,
      location: json['location'] as String?,
      points: json['points'] as int?,
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
      'itemType': itemType,
      'title': title,
      'photos': photos,
      'description': description,
      'location': location,
      'points': points,
      'quantity': quantity,
      'status': status,
      'qrCode': qrCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
