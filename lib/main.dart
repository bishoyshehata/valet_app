import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_orders_use_case.dart';
import 'package:valet_app/valete/domain/usecases/update_order_status_use_case.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_events.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
import 'core/notifications/firebase_notifications/firebase.dart';
import 'core/services/services_locator.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default_notification_channel_id', // لازم تطابق اللي في manifest وstrings.xml
  'Default Notifications',
  description: 'This channel is used for default notifications.',
  importance: Importance.high,
);
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔄 Handling a background message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // إنشاء قناة الإشعارات
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // لو عايز تطلب POST_NOTIFICATIONS على Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseFcm.setUp();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final fcmToken = await messaging.getToken();
  print("📲 FCM Token: $fcmToken");

  ServicesLocator().onInit();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            sl<MyGaragesUseCase>(),
            sl<MyOrdersUseCase>(),
            sl<UpdateOrderStatusUseCase>(),
          )
            ..add(GetMyGaragesEvent())
            ..add(GetMyOrdersEvent(0)),
        ),
      ],
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Valet App',
          home:MainScreen(),
        );
      },
    );
  }
}
