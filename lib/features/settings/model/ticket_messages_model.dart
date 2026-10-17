import 'dart:convert';

class TicketMessagesResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  TicketMessagesData? data;

  TicketMessagesResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory TicketMessagesResponseModel.fromRawJson(String str) =>
      TicketMessagesResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TicketMessagesResponseModel.fromJson(Map<String, dynamic> json) =>
      TicketMessagesResponseModel(
        success: json['success'] as bool?,
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? TicketMessagesData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}

class TicketMessagesData {
  String? ticketId;
  String? status;
  String? statusLabel;
  int? totalMessages;
  List<TicketChatMessage>? messages;

  TicketMessagesData({
    this.ticketId,
    this.status,
    this.statusLabel,
    this.totalMessages,
    this.messages,
  });

  factory TicketMessagesData.fromJson(Map<String, dynamic> json) {
    List<TicketChatMessage>? msgList;
    if (json['messages'] != null && json['messages'] is List) {
      msgList = (json['messages'] as List)
          .whereType<Map<String, dynamic>>()
          .map((x) => TicketChatMessage.fromJson(x))
          .toList();
    }

    return TicketMessagesData(
      ticketId: json['ticketId'] as String?,
      status: json['status'] as String?,
      statusLabel: json['statusLabel'] as String?,
      totalMessages: json['totalMessages'] as int?,
      messages: msgList,
    );
  }

  Map<String, dynamic> toJson() => {
        'ticketId': ticketId,
        'status': status,
        'statusLabel': statusLabel,
        'totalMessages': totalMessages,
        'messages': messages?.map((x) => x.toJson()).toList(),
      };
}

class TicketChatMessage {
  String? id;
  String? senderId;
  String? senderName;
  String? senderRole;
  String? senderType;
  bool? isMyMessage;
  bool? isSupportReply;
  String? alignment;
  String? message;
  String? formattedTime;
  String? formattedDate;
  String? timeAgo;
  String? createdAt;

  TicketChatMessage({
    this.id,
    this.senderId,
    this.senderName,
    this.senderRole,
    this.senderType,
    this.isMyMessage,
    this.isSupportReply,
    this.alignment,
    this.message,
    this.formattedTime,
    this.formattedDate,
    this.timeAgo,
    this.createdAt,
  });

  factory TicketChatMessage.fromJson(Map<String, dynamic> json) =>
      TicketChatMessage(
        id: (json['_id'] ?? json['id']) as String?,
        senderId: json['senderId'] as String?,
        senderName: json['senderName'] as String?,
        senderRole: json['senderRole'] as String?,
        senderType: json['senderType'] as String?,
        isMyMessage: json['isMyMessage'] as bool?,
        isSupportReply: json['isSupportReply'] as bool?,
        alignment: json['alignment'] as String?,
        message: json['message'] as String?,
        formattedTime: json['formattedTime'] as String?,
        formattedDate: json['formattedDate'] as String?,
        timeAgo: json['timeAgo'] as String?,
        createdAt: json['createdAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'senderId': senderId,
        'senderName': senderName,
        'senderRole': senderRole,
        'senderType': senderType,
        'isMyMessage': isMyMessage,
        'isSupportReply': isSupportReply,
        'alignment': alignment,
        'message': message,
        'formattedTime': formattedTime,
        'formattedDate': formattedDate,
        'timeAgo': timeAgo,
        'createdAt': createdAt,
      };

  bool get isSenderUser =>
      isMyMessage == true ||
      (alignment != null && alignment!.toLowerCase() == 'right');
}

class SendTicketMessageResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  SendTicketMessageData? data;

  SendTicketMessageResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory SendTicketMessageResponseModel.fromRawJson(String str) =>
      SendTicketMessageResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendTicketMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      SendTicketMessageResponseModel(
        success: json['success'] as bool?,
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
        data: json['data'] != null && json['data'] is Map<String, dynamic>
            ? SendTicketMessageData.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}

class SendTicketMessageData {
  TicketChatMessage? sentMessage;

  SendTicketMessageData({this.sentMessage});

  factory SendTicketMessageData.fromJson(Map<String, dynamic> json) =>
      SendTicketMessageData(
        sentMessage: json['sentMessage'] != null &&
                json['sentMessage'] is Map<String, dynamic>
            ? TicketChatMessage.fromJson(
                json['sentMessage'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'sentMessage': sentMessage?.toJson(),
      };
}
