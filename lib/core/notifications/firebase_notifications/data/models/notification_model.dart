import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  final String? type;
  final Map<String, dynamic>? data;

  NotificationModel({
    required super.title,
    required super.body,
    this.type,
    this.data,
  });

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    final rawData = message.data;

    // لو الداتا جواها كمان json string، فكّها
    Map<String, dynamic>? nestedData;
    if (rawData['data'] != null) {
      try {
        nestedData = jsonDecode(rawData['data']);
      } catch (_) {}
    }

    return NotificationModel(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      type: rawData['type'],
      data: nestedData,
    );
  }
}
