import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationEntity notification;

  NotificationWidget({required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.title),
      subtitle: Text(notification.body),
    );
  }
}
