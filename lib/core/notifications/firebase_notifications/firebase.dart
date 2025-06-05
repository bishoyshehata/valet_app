import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import '../../../valete/presentation/controllers/myorders/my_orders_bloc.dart';
import '../../../valete/presentation/controllers/myorders/my_orders_events.dart';
import 'data/data_sources/notificaiton_local_data_source.dart';
import 'data/data_sources/notification_remote_data_source.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/entities/notification_entity.dart';
import 'domain/use_cases/get_notifications_use_case.dart';
import 'domain/use_cases/request_permission_use_case.dart';

final getIt = GetIt.instance;
class NotificationService {
  static Future<void> init(BuildContext context) async {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message received');
      print(message.data);
      context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
    });

    // Background (when app is opened by tapping the notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📩 Opened from background');
      print(message.data);
      context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
    });

    // Terminated (cold start)
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('📩 Opened from terminated');
      print(initialMessage.data);
      context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
    }
  }
}

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