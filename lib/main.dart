import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_events.dart';
import 'package:valet_app/valete/presentation/controllers/myorders/my_orders_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/myorders/my_orders_events.dart';
import 'package:valet_app/valete/presentation/controllers/profile/delete_bloc.dart';
import 'package:valet_app/valete/presentation/screens/splash/splash.dart';
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
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('deviceToken', fcmToken.toString());

  print("📲 FCM Token: $fcmToken");

  ServicesLocator().onInit();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) =>
          sl<HomeBloc>()..add(GetMyGaragesEvent())
        ), BlocProvider<MyOrdersBloc>(
          create: (context) =>
          sl<MyOrdersBloc>()
        ),BlocProvider<DeleteBloc>(
          create: (context) =>
          sl<DeleteBloc>()
        ),
        // BlocProviders تانية لو فيه
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();

    // App is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message received');
      print('📩 Foreground message received ${message.data}');
      context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
    });

    // App is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📩 App opened from background notification');
      print('📩 App opened from background notification ${message.data}');
      context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
    });

    // App launched from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('📩 App launched from terminated by notification');
        context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
      }
    });
  }
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
          home: SplashScreen(),
        );
      },
    );
  }
}
