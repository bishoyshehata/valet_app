import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/core/services/services_locator.dart';
import 'package:valet_app/valete/presentation/screens/splash/splash.dart';
import '../../valete/presentation/controllers/profile/profile_bloc.dart';
import '../../valete/presentation/controllers/profile/profile_events.dart';
import '../../valete/presentation/screens/login/login.dart';
import '../../valete/presentation/screens/settings/force_update_screen.dart';
import '../../valete/presentation/screens/valet_home/valet_main.dart';
import '../utils/enums.dart';

Future<Widget> determineStartScreen() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final currentVersion = (await PackageInfo.fromPlatform()).version;

  final bloc = sl<ProfileBloc>();
  bloc.add(GetSettingsEvent());

  // انتظر لحد ما الـ state يبقى loaded
  final loadedState = await bloc.stream.firstWhere(
        (state) => state.settingsState == RequestState.loaded,
  );
  print("androidVersion: ${loadedState.androidVersion}");
  print("iosVersion: ${loadedState.iosVersion}");

  final requiredVersion = Platform.isAndroid
      ? loadedState.androidVersion ?? "1.0.0"
      : loadedState.iosVersion ?? "1.0.0";

  return !(isValidVersion(currentVersion, requiredVersion))
      ? const NotUpdatedVersion()
      : accessToken != null
      ? MainScreen()
      : LoginScreen();
}


bool isValidVersion(String current, String required) {
  int currentVersion = versionToInt(current);   // 10203
  int requiredVersion = versionToInt(required);
  print("currentVersion $currentVersion");
  print("requiredVersion $requiredVersion");

  return currentVersion >= requiredVersion;

}
int versionToInt(String version) {
  List<int> parts = version.split('.').map(int.parse).toList();
  while (parts.length < 3) {
    parts.add(0); // تأكد من وجود 3 أجزاء
  }
  return parts[0] * 100 + parts[1] * 10 + parts[2]; // يعطينا رقم كبير
}

