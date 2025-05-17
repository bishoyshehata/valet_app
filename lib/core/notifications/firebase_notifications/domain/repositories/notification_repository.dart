import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> requestPermission();
  Stream<NotificationEntity> getNotifications();
}
