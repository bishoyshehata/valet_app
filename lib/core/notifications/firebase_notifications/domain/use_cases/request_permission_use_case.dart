import '../repositories/notification_repository.dart';

class RequestPermissionUseCase {
  final NotificationRepository repository;

  RequestPermissionUseCase(this.repository);

  Future<void> call() {
    return repository.requestPermission();
  }
}
