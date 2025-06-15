import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_states.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_states.dart';
import 'package:valet_app/valete/presentation/controllers/myorders/my_orders_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_states.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import 'package:valet_app/valete/presentation/screens/login/login.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_home_screen.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/profile/valet_profile.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/utils/enums.dart';
import '../../controllers/home/home_events.dart';
import '../../controllers/myorders/my_orders_events.dart';
import '../../resources/strings_manager.dart';
import 'order_status/orders_status.dart';

class MainScreen extends StatelessWidget {
  final List<Widget> screens = [
    ValetHomeScreen(),
    OrdersScreen(),
    ValetProfileScreen(),
  ];


   MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(

    builder: (context, state) {
      final List<String> titles = [
      AppLocalizations.of(context)!.garages,
      AppLocalizations.of(context)!.orders,
      AppLocalizations.of(context)!.profile,
    ];

    final locale = Localizations.localeOf(context);
      return Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,

        child: Scaffold(
          backgroundColor: ColorManager.background,
          body: screens[state.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: ColorManager.background,
            currentIndex: state.currentIndex,
            selectedItemColor: ColorManager.primary,
            unselectedItemColor: ColorManager.white,
            onTap: (index) {

              context.read<HomeBloc>().add(ChangeTabEvent(index));
            },
            unselectedLabelStyle:GoogleFonts.cairo(color: ColorManager.white) ,
            selectedLabelStyle: GoogleFonts.cairo(color: ColorManager.primary),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_work_outlined, color: ColorManager.white,),
                label: AppLocalizations.of(context)!.theGarage,
                activeIcon: Icon(Icons.home_work_rounded, color: ColorManager.primary,),
              ),
               BottomNavigationBarItem(
                icon: Icon(Icons.note_alt_outlined, color: ColorManager.white,),
                label: AppLocalizations.of(context)!.orders,
                 activeIcon: Icon(Icons.note_alt_rounded, color: ColorManager.primary,),
              ),
              BottomNavigationBarItem(
                icon: BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    return FutureBuilder<int?>(
                  future: SharedPreferences.getInstance()
                      .then((prefs) => prefs.getInt('status')), // تحميل الحالة من الشيرد
                  builder: (context, snapshot) {
                    final statusIndex = snapshot.data ?? 0; // 0 = Active بشكل افتراضي
                    final status = Status.values[statusIndex];

                    // اختار اللون حسب الحالة
                    Color statusColor;
                    switch (status) {
                      case Status.Active:
                        statusColor = Colors.green;
                        break;
                      case Status.Busy:
                        statusColor = Colors.orange;
                        break;
                      case Status.DisActive:
                        statusColor = Colors.red;
                        break;
                    }

                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Icon(Icons.person_2_outlined, color: ColorManager.white),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
  },
),
                activeIcon: BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    return FutureBuilder<int?>(
                  future: SharedPreferences.getInstance()
                      .then((prefs) => prefs.getInt('status')),
                  builder: (context, snapshot) {
                    final statusIndex = snapshot.data ?? 0;
                    final status = Status.values[statusIndex];

                    Color statusColor;
                    switch (status) {
                      case Status.Active:
                        statusColor = Colors.green;
                        break;
                      case Status.Busy:
                        statusColor = Colors.orange;
                        break;
                      case Status.DisActive:
                        statusColor = Colors.red;
                        break;
                    }

                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Icon(Icons.person, color: ColorManager.primary),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
  },
),
                label: AppLocalizations.of(context)!.profile,
                backgroundColor: ColorManager.primary,
              ),

            ],
          ),
        ),
      );
    },
        );
  }
}
