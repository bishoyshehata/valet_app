import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'data/data_sources/notificaiton_local_data_source.dart';
import 'data/data_sources/notification_remote_data_source.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/entities/notification_entity.dart';
import 'domain/use_cases/get_notifications_use_case.dart';
import 'domain/use_cases/request_permission_use_case.dart';

final getIt = GetIt.instance;

class FirebaseFcm {

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> setUp() async {
    await Firebase.initializeApp();

    // تسجيل الكائنات في GetIt
    getIt.registerSingleton<NotificationRemoteDataSource>(NotificationRemoteDataSource());
    getIt.registerSingleton<NotificationLocalDataSource>(NotificationLocalDataSource());

    final repository = NotificationRepositoryImpl(
      getIt<NotificationRemoteDataSource>(),
      getIt<NotificationLocalDataSource>(),
    );


    getIt.registerSingleton<RequestPermissionUseCase>(RequestPermissionUseCase(repository));
    getIt.registerSingleton<GetNotificationsUseCase>(GetNotificationsUseCase(repository));



    // الاشتراك في الإشعارات
    _requestPermission();
    _subscribeToNotifications();
    getFcmToken();
    _subscribeToTopics();

  }

  static Future<void> _requestPermission() async {
    await getIt<GetNotificationsUseCase>().repository.requestPermission();
  }

  static void _subscribeToNotifications() {
    getIt<GetNotificationsUseCase>()().listen((NotificationEntity notification) {
      _showNotification(notification);
    });
  }

  static Future<String?> getFcmToken() async {
    try {
      String? token =  await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
      return token ;
    }catch(e){
      print(e);
    }
    return null;
  }

  // دالة لإرسال إشعار اختبار
  static void _subscribeToTopics() {
    getIt<NotificationRemoteDataSource>().subscribeToTopic("test_topic");
    // getIt<NotificationRemoteDataSource>().subscribeToTopic("test_topic");
  }


  static void _showNotification(NotificationEntity message) async {
    // إعدادات Android
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // استخدم نفس معرف القناة
      'Your Channel Name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      ticker: 'New Notification',
      enableLights: true,
      priority: Priority.high,
      color: ColorManager.white,
      icon: '@drawable/app_icon',
      visibility: NotificationVisibility.public,
    );

    // إعدادات iOS
    DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    // إعدادات الإشعار العامة
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.title ?? '',
      message.body ?? '',
      platformChannelSpecifics,
      payload: 'Notification Payload', // يمكنك تمرير بيانات إضافية هنا
    );
  }

}