import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_states.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_home_screen.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_profile.dart';
import '../../../../core/services/services_locator.dart';
import '../../../domain/usecases/my_garages_use_case.dart';
import '../../../domain/usecases/my_orders_use_case.dart';
import '../../controllers/home/home_events.dart';
import 'orders_status.dart';

class MainScreen extends StatelessWidget {
  final List<Widget> screens = [
    ValetHomeScreen(),
    OrdersScreen(),
    ValetProfileScreen(),
  ];

  final List<String> titles = [
    'الجراجات',
    'الطلبات',
    'شخصي',
  ];

   MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(sl<MyGaragesUseCase>(),sl<MyOrdersUseCase>()),
      child: BlocBuilder<HomeBloc, HomeState>(

        builder: (context, state) {
        print(state.myGaragesState);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: ColorManager.background,
              body: screens[state.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: ColorManager.background,
                currentIndex: state.currentIndex,
                selectedItemColor: ColorManager.primary,
                unselectedItemColor: ColorManager.grey,
                onTap: (index) {
                  context.read<HomeBloc>().add(ChangeTabEvent(index));
                },
                unselectedLabelStyle:GoogleFonts.cairo(color: ColorManager.grey) ,
                selectedLabelStyle: GoogleFonts.cairo(color: ColorManager.primary),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_work_outlined, color: ColorManager.grey,),
                    label: 'الرئيسية',
                    activeIcon: Icon(Icons.home_work_rounded, color: ColorManager.primary,),
                  ),
                   BottomNavigationBarItem(
                    icon: Icon(Icons.note_alt_outlined, color: ColorManager.grey,),
                    label: 'الطلبات',
                     activeIcon: Icon(Icons.note_alt_rounded, color: ColorManager.primary,),
                  ),
                   BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_outlined, color: ColorManager.grey,),
                    label: 'شخصي',
                     activeIcon: Icon(Icons.person, color: ColorManager.primary,),backgroundColor: ColorManager.primary

                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
