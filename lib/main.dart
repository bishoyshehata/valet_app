import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_events.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/myorders/my_orders_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/myorders/my_orders_events.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_events.dart';
import 'package:valet_app/valete/presentation/screens/splash/splash.dart';
import 'core/notifications/firebase_notifications/firebase.dart';
import 'core/services/services_locator.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseFcm.setUp();
  final fcmToken = await FirebaseFcm.getFcmToken();
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('deviceToken', fcmToken.toString());
  print(fcmToken);
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
        ),BlocProvider<ProfileBloc>(
          create: (context) =>
          sl<ProfileBloc>()..add(GetSettingsEvent())
        ),BlocProvider<LoginBloc>(
          create: (context) =>
          sl<LoginBloc>()
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.init(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(GetSettingsEvent());
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
          title: 'Lag Valet',
          home: SplashScreen(),
        );
      },
    );
  }
}
