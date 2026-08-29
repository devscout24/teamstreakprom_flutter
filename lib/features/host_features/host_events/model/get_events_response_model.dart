class GetEventsResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  Meta? meta;
  List<EventItem>? data;

  GetEventsResponseModel(
      {this.success, this.statusCode, this.message, this.meta, this.data});

  GetEventsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <EventItem>[];
      json['data'].forEach((v) {
        data!.add(EventItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPage'] = totalPage;
    return data;
  }
}

class EventItem {
  String? sId;
  HostInfo? hostId;
  CategoryInfo? categoryId;
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
  List<String>? images;
  List<EventArtistInfo>? artistInfo;
  List<EventReward>? rewards;
  String? createdAt;
  String? updatedAt;
  int? iV;

  EventItem(
      {this.sId,
      this.hostId,
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
      this.images,
      this.artistInfo,
      this.rewards,
      this.createdAt,
      this.updatedAt,
      this.iV});

  EventItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    hostId =
        json['hostId'] != null ? HostInfo.fromJson(json['hostId']) : null;
    categoryId = json['categoryId'] != null
        ? CategoryInfo.fromJson(json['categoryId'])
        : null;
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
    images = json['images']?.cast<String>();
    if (json['artistInfo'] != null) {
      artistInfo = <EventArtistInfo>[];
      json['artistInfo'].forEach((v) {
        artistInfo!.add(EventArtistInfo.fromJson(v));
      });
    }
    if (json['rewards'] != null) {
      rewards = <EventReward>[];
      json['rewards'].forEach((v) {
        rewards!.add(EventReward.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (hostId != null) {
      data['hostId'] = hostId!.toJson();
    }
    if (categoryId != null) {
      data['categoryId'] = categoryId!.toJson();
    }
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
    data['images'] = images;
    if (artistInfo != null) {
      data['artistInfo'] = artistInfo!.map((v) => v.toJson()).toList();
    }
    if (rewards != null) {
      data['rewards'] = rewards!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class HostInfo {
  String? sId;
  String? name;
  String? email;
  String? role;

  HostInfo({this.sId, this.name, this.email, this.role});

  HostInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}

class CategoryInfo {
  String? sId;
  String? name;
  String? description;

  CategoryInfo({this.sId, this.name, this.description});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class EventArtistInfo {
  String? name;
  String? role;
  String? image;
  EventSocialMediaLinks? socialMediaLinks;

  EventArtistInfo({this.name, this.role, this.image, this.socialMediaLinks});

  EventArtistInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    image = json['image'];
    socialMediaLinks = json['socialMediaLinks'] != null
        ? EventSocialMediaLinks.fromJson(json['socialMediaLinks'])
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

class EventSocialMediaLinks {
  String? instagram;
  String? spotify;
  String? facebook;
  String? twitter;

  EventSocialMediaLinks({this.instagram, this.spotify, this.facebook, this.twitter});

  EventSocialMediaLinks.fromJson(Map<String, dynamic> json) {
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

class EventReward {
  String? title;
  String? description;
  int? pointsRequired;
  int? stock;
  List<String>? images;
  String? sId;
  String? createdAt;
  String? updatedAt;

  EventReward(
      {this.title,
      this.description,
      this.pointsRequired,
      this.stock,
      this.images,
      this.sId,
      this.createdAt,
      this.updatedAt});

  EventReward.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    pointsRequired = json['pointsRequired'];
    stock = json['stock'];
    images = json['images']?.cast<String>();
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
    data['images'] = images;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
