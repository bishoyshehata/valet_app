import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_events.dart';
import 'package:valet_app/valete/presentation/controllers/language/language_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/language/language_events.dart';
import 'package:valet_app/valete/presentation/controllers/language/language_state.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/myorders/my_orders_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_events.dart';
import 'package:valet_app/valete/presentation/screens/splash/splash.dart';
import 'core/l10n/app_locale.dart';
import 'core/notifications/firebase_notifications/firebase.dart';
import 'core/services/services_locator.dart';
import 'core/utils/preferences_service.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseFcm.setUp();
  final fcmToken = await FirebaseFcm.getFcmToken();
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('deviceToken', fcmToken.toString());
  final prefsService = PreferencesService();
  final savedLocale = await prefsService.getLanguage();

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
        ),BlocProvider<LanguageBloc>(
          create: (context) {
            final bloc = sl<LanguageBloc>();
            bloc.add(ChangeLanguage(savedLocale)); // إرسال اللغة المحفوظة
            return bloc;
          },
        ),

        // BlocProviders تانية لو فيه
      ],
      child: MyApp(savedLocale: savedLocale),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Locale savedLocale;
  const MyApp({super.key, required this.savedLocale});

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
         return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            final locale = (state is LanguageInitial)
                ? state.locale
                : (state is LanguageChanged)
                ? state.locale
                : const Locale('ar'); // fallback
            return MaterialApp(
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              debugShowCheckedModeBanner: false,
              title: 'Lag Valet',
              home: const SplashScreen(),
            );
          },
        );

      },
    );
  }
}
