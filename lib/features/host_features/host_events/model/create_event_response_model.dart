import 'package:flutter/foundation.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart';

class CreateEventResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  EventData? data;

  CreateEventResponseModel(
      {this.success, this.statusCode, this.message, this.data});

  CreateEventResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? EventData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class EventData {
  String? hostId;
  String? categoryId;
  String? title;
  double? latitude;
  double? longitude;
  int? ageRestriction;
  String? placeName;
  String? description;
  String? startDate;
  String? endDate;
  double? ticketPrice;
  int? stock;
  List<PriceCategory>? priceCategories;
  List<String>? images;
  List<ArtistInfo>? artistInfo;
  List<Rewards>? rewards;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  EventData(
      {this.hostId,
      this.categoryId,
      this.title,
      this.latitude,
      this.longitude,
      this.ageRestriction,
      this.placeName,
      this.description,
      this.startDate,
      this.endDate,
      this.ticketPrice,
      this.stock,
      this.priceCategories,
      this.images,
      this.artistInfo,
      this.rewards,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  EventData.fromJson(Map<String, dynamic> json) {
    try {
      hostId = json['hostId'] is Map ? json['hostId']['_id'] ?? json['hostId'].toString() : json['hostId'];
      categoryId = json['categoryId'] is Map ? json['categoryId']['_id'] ?? json['categoryId'].toString() : json['categoryId'];
      title = json['title'];
      latitude = (json['latitude'] != null) ? json['latitude'].toDouble() : null;
      longitude = (json['longitude'] != null) ? json['longitude'].toDouble() : null;
      ageRestriction = json['ageRestriction'];
      placeName = json['placeName'];
      description = json['description'];
      startDate = json['startDate'];
      endDate = json['endDate'];
      ticketPrice = (json['ticketPrice'] != null) ? json['ticketPrice'].toDouble() : null;
      stock = json['stock'];
      if (json['priceCategories'] != null) {
        priceCategories = <PriceCategory>[];
        json['priceCategories'].forEach((v) {
          priceCategories!.add(PriceCategory.fromJson(v));
        });
      }
      images = json['images']?.cast<String>();
      if (json['artistInfo'] != null) {
        artistInfo = <ArtistInfo>[];
        json['artistInfo'].forEach((v) {
          artistInfo!.add(ArtistInfo.fromJson(v));
        });
      }
      if (json['rewards'] != null) {
        rewards = <Rewards>[];
        json['rewards'].forEach((v) {
          rewards!.add(Rewards.fromJson(v));
        });
      }
      sId = json['_id'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
      iV = json['__v'];
    } catch (e, stack) {
      debugPrint('Error parsing EventData.fromJson: $e\n$stack');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hostId'] = hostId;
    data['categoryId'] = categoryId;
    data['title'] = title;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['ageRestriction'] = ageRestriction;
    data['placeName'] = placeName;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['ticketPrice'] = ticketPrice;
    data['stock'] = stock;
    if (priceCategories != null) {
      data['priceCategories'] =
          priceCategories!.map((v) => v.toJson()).toList();
    }
    data['images'] = images;
    if (artistInfo != null) {
      data['artistInfo'] = artistInfo!.map((v) => v.toJson()).toList();
    }
    if (rewards != null) {
      data['rewards'] = rewards!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ArtistInfo {
  String? name;
  String? role;
  String? image;
  SocialMediaLinks? socialMediaLinks;

  ArtistInfo({this.name, this.role, this.image, this.socialMediaLinks});

  ArtistInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    
    if (json['image'] is Map) {
      image = json['image']['url'] ?? json['image'].toString();
    } else if (json['image'] is List) {
      image = (json['image'] as List).isNotEmpty ? json['image'][0].toString() : null;
    } else {
      image = json['image'];
    }
    
    socialMediaLinks = json['socialMediaLinks'] != null
        ? SocialMediaLinks.fromJson(json['socialMediaLinks'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['role'] = role;
    data['image'] = image;
    if (socialMediaLinks != null) {
      data['socialMediaLinks'] = socialMediaLinks!.toJson();
    }
    return data;
  }
}

class SocialMediaLinks {
  String? instagram;
  String? spotify;
  String? facebook;
  String? twitter;

  SocialMediaLinks({this.instagram, this.spotify, this.facebook, this.twitter});

  SocialMediaLinks.fromJson(Map<String, dynamic> json) {
    instagram = json['instagram'];
    spotify = json['spotify'];
    facebook = json['facebook'];
    twitter = json['twitter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instagram'] = instagram;
    data['spotify'] = spotify;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    return data;
  }
}

class Rewards {
  String? title;
  String? description;
  int? pointsRequired;
  int? stock;
  String? image;
  String? sId;
  String? createdAt;
  String? updatedAt;

  Rewards(
      {this.title,
      this.description,
      this.pointsRequired,
      this.stock,
      this.image,
      this.sId,
      this.createdAt,
      this.updatedAt});

  Rewards.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    pointsRequired = json['pointsRequired'];
    stock = json['stock'];
    
    // Safely parse image which might be a String, List, or Map depending on backend
    if (json['image'] is Map) {
      image = json['image']['url'] ?? json['image'].toString();
    } else if (json['image'] is List) {
      image = (json['image'] as List).isNotEmpty ? json['image'][0].toString() : null;
    } else {
      image = json['image'];
    }
    
    // Also try images if image is null
    if (image == null && json['images'] != null) {
      if (json['images'] is List && (json['images'] as List).isNotEmpty) {
        image = json['images'][0].toString();
      }
    }

    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['pointsRequired'] = pointsRequired;
    data['stock'] = stock;
    data['image'] = image;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
