


import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationLocalDataSource{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationLocalDataSource() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    // تعريف قناة الإشعارات
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // معرف القناة
      'Your Channel Name', // اسم القناة
      description: 'Your channel description', // وصف القناة
      importance: Importance.max,
    );

    // إنشاء القناة على النظام
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // إعدادات Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات iOS
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    // إعدادات التهيئة العامة
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );
  }

  Future<void> _onSelectNotification(NotificationResponse response) async {
    // التعامل مع النقر على الإشعار
    // يمكنك تنفيذ الإجراءات المناسبة هنا
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      // طلب الإذن على iOS
      NotificationSettings settings =
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('تم منح الإذن على iOS');
      } else {
        print('تم رفض الإذن أو لم يتم طلبه على iOS');
      }
    } else if (Platform.isAndroid) {
      // طلب الإذن على Android
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        print('تم منح الإذن على Android');
      } else {
        print('تم رفض الإذن أو لم يتم طلبه على Android');
      }
    }
  }

}