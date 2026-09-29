import 'dart:convert';

class MyOrdersResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  MyOrdersMeta? meta;
  List<MyOrderData>? data;

  MyOrdersResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  factory MyOrdersResponseModel.fromRawJson(String str) =>
      MyOrdersResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    List<MyOrderData>? dataList;
    if (json['data'] != null && json['data'] is List) {
      dataList = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((x) => MyOrderData.fromJson(x))
          .toList();
    }

    return MyOrdersResponseModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? MyOrdersMeta.fromJson(json['meta'] as Map<String, dynamic>)
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

class MyOrdersMeta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  MyOrdersMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory MyOrdersMeta.fromJson(Map<String, dynamic> json) => MyOrdersMeta(
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

class MyOrderData {
  String? id;
  String? user;
  MyOrderHost? hostId;
  MyOrderEvent? eventId;
  List<MyOrderTicketItem>? tickets;
  int? totalTicketQuantity;
  double? totalAmount;
  String? stripeSessionId;
  String? status;
  String? payoutStatus;
  double? hostPayoutAmount;
  double? platformFeeAmount;
  double? pointsEarned;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? qrCode;
  String? ticketId;

  MyOrderData({
    this.id,
    this.user,
    this.hostId,
    this.eventId,
    this.tickets,
    this.totalTicketQuantity,
    this.totalAmount,
    this.stripeSessionId,
    this.status,
    this.payoutStatus,
    this.hostPayoutAmount,
    this.platformFeeAmount,
    this.pointsEarned,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.qrCode,
    this.ticketId,
  });

  factory MyOrderData.fromJson(Map<String, dynamic> json) => MyOrderData(
        id: json['_id'] as String?,
        user: json['user'] as String?,
        hostId: json['hostId'] != null && json['hostId'] is Map<String, dynamic>
            ? MyOrderHost.fromJson(json['hostId'] as Map<String, dynamic>)
            : null,
        eventId:
            json['eventId'] != null && json['eventId'] is Map<String, dynamic>
                ? MyOrderEvent.fromJson(json['eventId'] as Map<String, dynamic>)
                : null,
        tickets: json['tickets'] != null && json['tickets'] is List
            ? (json['tickets'] as List)
                .whereType<Map<String, dynamic>>()
                .map((x) => MyOrderTicketItem.fromJson(x))
                .toList()
            : null,
        totalTicketQuantity: json['totalTicketQuantity'] is num
            ? (json['totalTicketQuantity'] as num).toInt()
            : int.tryParse(json['totalTicketQuantity']?.toString() ?? ''),
        totalAmount: json['totalAmount'] != null
            ? (json['totalAmount'] as num).toDouble()
            : null,
        stripeSessionId: json['stripeSessionId'] as String?,
        status: json['status'] as String?,
        payoutStatus: json['payoutStatus'] as String?,
        hostPayoutAmount: json['hostPayoutAmount'] != null
            ? (json['hostPayoutAmount'] as num).toDouble()
            : null,
        platformFeeAmount: json['platformFeeAmount'] != null
            ? (json['platformFeeAmount'] as num).toDouble()
            : null,
        pointsEarned: json['pointsEarned'] != null
            ? (json['pointsEarned'] as num).toDouble()
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
        v: json['__v'] as int?,
        qrCode: json['qrCode'] as String?,
        ticketId: json['ticketId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'hostId': hostId?.toJson(),
        'eventId': eventId?.toJson(),
        'tickets': tickets?.map((x) => x.toJson()).toList(),
        'totalTicketQuantity': totalTicketQuantity,
        'totalAmount': totalAmount,
        'stripeSessionId': stripeSessionId,
        'status': status,
        'payoutStatus': payoutStatus,
        'hostPayoutAmount': hostPayoutAmount,
        'platformFeeAmount': platformFeeAmount,
        'pointsEarned': pointsEarned,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'qrCode': qrCode,
        'ticketId': ticketId,
      };
}

class MyOrderHost {
  String? id;
  String? name;
  String? profileImage;
  MyOrderBusinessProfile? businessProfile;

  MyOrderHost({
    this.id,
    this.name,
    this.profileImage,
    this.businessProfile,
  });

  factory MyOrderHost.fromJson(Map<String, dynamic> json) => MyOrderHost(
        id: json['_id'] ?? json['id'] as String?,
        name: json['name'] as String?,
        profileImage: json['profileImage'] as String?,
        businessProfile: json['businessProfile'] != null &&
                json['businessProfile'] is Map<String, dynamic>
            ? MyOrderBusinessProfile.fromJson(
                json['businessProfile'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'profileImage': profileImage,
        'businessProfile': businessProfile?.toJson(),
        'id': id,
      };
}

class MyOrderBusinessProfile {
  String? id;
  String? userId;
  String? businessName;

  MyOrderBusinessProfile({
    this.id,
    this.userId,
    this.businessName,
  });

  factory MyOrderBusinessProfile.fromJson(Map<String, dynamic> json) =>
      MyOrderBusinessProfile(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
        businessName: json['businessName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'businessName': businessName,
      };
}

class MyOrderEvent {
  String? id;
  String? title;
  String? placeName;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  List<MyOrderPriceCategory>? priceCategories;
  List<String>? images;

  MyOrderEvent({
    this.id,
    this.title,
    this.placeName,
    this.description,
    this.startDate,
    this.endDate,
    this.priceCategories,
    this.images,
  });

  factory MyOrderEvent.fromJson(Map<String, dynamic> json) => MyOrderEvent(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        placeName: json['placeName'] as String?,
        description: json['description'] as String?,
        startDate: json['startDate'] != null
            ? DateTime.tryParse(json['startDate'].toString())
            : null,
        endDate: json['endDate'] != null
            ? DateTime.tryParse(json['endDate'].toString())
            : null,
        priceCategories: json['priceCategories'] != null &&
                json['priceCategories'] is List
            ? (json['priceCategories'] as List)
                .whereType<Map<String, dynamic>>()
                .map((x) => MyOrderPriceCategory.fromJson(x))
                .toList()
            : null,
        images: json['images'] != null && json['images'] is List
            ? (json['images'] as List)
                .map((e) => e?.toString() ?? '')
                .where((e) => e.isNotEmpty)
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'placeName': placeName,
        'description': description,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'priceCategories': priceCategories?.map((x) => x.toJson()).toList(),
        'images': images,
      };
}

class MyOrderPriceCategory {
  String? id;
  String? name;
  double? price;
  int? stock;
  DateTime? createdAt;
  DateTime? updatedAt;

  MyOrderPriceCategory({
    this.id,
    this.name,
    this.price,
    this.stock,
    this.createdAt,
    this.updatedAt,
  });

  factory MyOrderPriceCategory.fromJson(Map<String, dynamic> json) =>
      MyOrderPriceCategory(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        price: json['price'] != null
            ? (json['price'] as num).toDouble()
            : null,
        stock: json['stock'] is num
            ? (json['stock'] as num).toInt()
            : int.tryParse(json['stock']?.toString() ?? ''),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'price': price,
        'stock': stock,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class MyOrderTicketItem {
  String? priceCategoryId;
  String? categoryName;
  double? unitPrice;
  int? quantity;

  MyOrderTicketItem({
    this.priceCategoryId,
    this.categoryName,
    this.unitPrice,
    this.quantity,
  });

  factory MyOrderTicketItem.fromJson(Map<String, dynamic> json) =>
      MyOrderTicketItem(
        priceCategoryId: json['priceCategoryId'] as String?,
        categoryName: json['categoryName'] as String?,
        unitPrice: json['unitPrice'] != null
            ? (json['unitPrice'] as num).toDouble()
            : null,
        quantity: json['quantity'] is num
            ? (json['quantity'] as num).toInt()
            : int.tryParse(json['quantity']?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'priceCategoryId': priceCategoryId,
        'categoryName': categoryName,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };
}
