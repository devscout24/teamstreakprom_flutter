import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../gen/colors.gen.dart';

class MySupportTicketsModel {
  bool? success;
  int? statusCode;
  String? message;
  SupportTicketsMeta? meta;
  List<SupportTicketItem>? data;

  MySupportTicketsModel({
    this.success,
    this.statusCode,
    this.message,
    this.meta,
    this.data,
  });

  factory MySupportTicketsModel.fromRawJson(String str) =>
      MySupportTicketsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MySupportTicketsModel.fromJson(Map<String, dynamic> json) {
    List<SupportTicketItem>? dataList;
    if (json['data'] != null && json['data'] is List) {
      dataList = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((x) => SupportTicketItem.fromJson(x))
          .toList();
    }

    return MySupportTicketsModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      meta: json['meta'] != null && json['meta'] is Map<String, dynamic>
          ? SupportTicketsMeta.fromJson(json['meta'] as Map<String, dynamic>)
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

class SupportTicketsMeta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  SupportTicketsMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory SupportTicketsMeta.fromJson(Map<String, dynamic> json) =>
      SupportTicketsMeta(
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

class SupportTicketItem {
  String? id;
  String? ticketId;
  String? title;
  String? description;
  String? status;
  String? statusLabel;
  SupportStatusBadge? statusBadge;
  String? priority;
  int? totalMessages;
  SupportLastMessage? lastMessage;
  String? createdAt;
  String? lastMessageAt;

  SupportTicketItem({
    this.id,
    this.ticketId,
    this.title,
    this.description,
    this.status,
    this.statusLabel,
    this.statusBadge,
    this.priority,
    this.totalMessages,
    this.lastMessage,
    this.createdAt,
    this.lastMessageAt,
  });

  factory SupportTicketItem.fromJson(Map<String, dynamic> json) =>
      SupportTicketItem(
        id: json['_id'] as String?,
        ticketId: json['ticketId'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        status: json['status'] as String?,
        statusLabel: json['statusLabel'] as String?,
        statusBadge: json['statusBadge'] != null &&
                json['statusBadge'] is Map<String, dynamic>
            ? SupportStatusBadge.fromJson(
                json['statusBadge'] as Map<String, dynamic>)
            : null,
        priority: json['priority'] as String?,
        totalMessages: json['totalMessages'] as int?,
        lastMessage: json['lastMessage'] != null &&
                json['lastMessage'] is Map<String, dynamic>
            ? SupportLastMessage.fromJson(
                json['lastMessage'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] as String?,
        lastMessageAt: json['lastMessageAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'ticketId': ticketId,
        'title': title,
        'description': description,
        'status': status,
        'statusLabel': statusLabel,
        'statusBadge': statusBadge?.toJson(),
        'priority': priority,
        'totalMessages': totalMessages,
        'lastMessage': lastMessage?.toJson(),
        'createdAt': createdAt,
        'lastMessageAt': lastMessageAt,
      };

  Color get resolvedStatusColor {
    final hexColor = statusBadge?.color;
    if (hexColor != null && hexColor.isNotEmpty) {
      try {
        final cleanHex = hexColor.replaceAll('#', '');
        if (cleanHex.length == 6) {
          return Color(int.parse('0xFF$cleanHex'));
        } else if (cleanHex.length == 8) {
          return Color(int.parse('0x$cleanHex'));
        }
      } catch (_) {}
    }

    final s = (statusLabel ?? status ?? '').toUpperCase();
    if (s.contains('REVIEW')) {
      return AppColors.primaryColorFirst;
    } else if (s.contains('SOLVE')) {
      return AppColors.primaryColorSecond;
    } else if (s.contains('CLOSE')) {
      return AppColors.c9B9C9A;
    }
    return AppColors.primaryColorFirst;
  }
}

class SupportStatusBadge {
  String? text;
  String? color;
  String? dotColor;

  SupportStatusBadge({
    this.text,
    this.color,
    this.dotColor,
  });

  factory SupportStatusBadge.fromJson(Map<String, dynamic> json) =>
      SupportStatusBadge(
        text: json['text'] as String?,
        color: json['color'] as String?,
        dotColor: json['dotColor'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'color': color,
        'dotColor': dotColor,
      };
}

class SupportLastMessage {
  String? message;
  String? senderName;
  String? senderRole;
  String? senderType;
  bool? isSupportReply;
  bool? isMyMessage;
  String? alignment;
  String? formattedTime;
  String? formattedDate;
  String? timeAgo;
  String? createdAt;

  SupportLastMessage({
    this.message,
    this.senderName,
    this.senderRole,
    this.senderType,
    this.isSupportReply,
    this.isMyMessage,
    this.alignment,
    this.formattedTime,
    this.formattedDate,
    this.timeAgo,
    this.createdAt,
  });

  factory SupportLastMessage.fromJson(Map<String, dynamic> json) =>
      SupportLastMessage(
        message: json['message'] as String?,
        senderName: json['senderName'] as String?,
        senderRole: json['senderRole'] as String?,
        senderType: json['senderType'] as String?,
        isSupportReply: json['isSupportReply'] as bool?,
        isMyMessage: json['isMyMessage'] as bool?,
        alignment: json['alignment'] as String?,
        formattedTime: json['formattedTime'] as String?,
        formattedDate: json['formattedDate'] as String?,
        timeAgo: json['timeAgo'] as String?,
        createdAt: json['createdAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'senderName': senderName,
        'senderRole': senderRole,
        'senderType': senderType,
        'isSupportReply': isSupportReply,
        'isMyMessage': isMyMessage,
        'alignment': alignment,
        'formattedTime': formattedTime,
        'formattedDate': formattedDate,
        'timeAgo': timeAgo,
        'createdAt': createdAt,
      };
}
