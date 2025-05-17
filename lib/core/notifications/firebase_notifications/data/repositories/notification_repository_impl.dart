import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notificaiton_local_data_source.dart';
import '../data_sources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl(this.remoteDataSource,this.localDataSource);

  @override
  Future<void> requestPermission() {
    return localDataSource.requestPermission();
  }

  @override
  Stream<NotificationEntity> getNotifications() {
    return remoteDataSource.getNotifications();
  }
}
