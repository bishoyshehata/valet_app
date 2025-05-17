import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_events.dart';
import '../../../valete/presentation/controllers/home/home_bloc.dart';
import '../../../valete/presentation/resources/colors_manager.dart';
import '../../services/services_locator.dart';
import 'data/data_sources/notificaiton_local_data_source.dart';
import 'data/data_sources/notification_remote_data_source.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/entities/notification_entity.dart';
import 'domain/use_cases/get_notifications_use_case.dart';
import 'domain/use_cases/request_permission_use_case.dart';
export 'presentation/pages/notification_page.dart';

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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('📩 Foreground message: ${message.notification!.title}');
        final homeBloc = sl<HomeBloc>();
        homeBloc.add(GetAllMyOrdersEvent());
      }
    });

    getIt.registerSingleton<RequestPermissionUseCase>(RequestPermissionUseCase(repository));
    getIt.registerSingleton<GetNotificationsUseCase>(GetNotificationsUseCase(repository));


    // الاشتراك في الإشعارات
    _requestPermission();
    _subscribeToNotifications();
    _getFcmToken();
    _subscribeToTopics();

  }
  // static void _handleIncomingNotification(Map<String, dynamic> data) {
  //   try {
  //     final String rawJson = data['data'];
  //     final Map<String, dynamic> innerData = json.decode(rawJson);
  //
  //     final String type = data['type'];
  //     print("sssssssssssaaaaaaaaaaaaaaaaaaaaaaa$type");
  //     if (type == "order_update") {
  //       final int orderId = innerData['id'];
  //       final String clientName = innerData['client'];
  //
  //       print("🔄 Order updated for client: $clientName - Order ID: $orderId");
  //
  //       // شغل الـ BLoC لتحديث الطلبات من السيرفر أو محلي
  //       final homeBloc = sl<HomeBloc>();
  //       homeBloc.add(GetAllMyOrdersEvent());
  //     }
  //   } catch (e) {
  //     print("❌ Error parsing notification data: $e");
  //   }
  // }
  static Future<void> _requestPermission() async {
    await getIt<GetNotificationsUseCase>().repository.requestPermission();
  }

  static void _subscribeToNotifications() {
    getIt<GetNotificationsUseCase>()().listen((NotificationEntity notification) {
      _showNotification(notification);
    });
  }

  static void _getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');
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
      color: ColorManager.error,
      icon: '@drawable/iti_red',
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