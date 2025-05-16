import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_orders_use_case.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_events.dart';
import 'package:valet_app/valete/presentation/screens/splash/splash.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_home_screen.dart';
import 'core/services/services_locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator().onInit();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(sl<MyGaragesUseCase>(),sl<MyOrdersUseCase>())..add(GetMyGaragesEvent())..add(GetMyOrdersEvent(0)),
        ),
        // BlocProviders تانية لو فيه
      ],
      child: MyApp(),
    ),
  );}

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
