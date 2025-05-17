import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_cases/get_notifications_use_case.dart';
import '../../domain/use_cases/request_permission_use_case.dart';
import '../../firebase.dart';
import '../widgets/notification_widget.dart';
import '../../data/data_sources/notification_remote_data_source.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final RequestPermissionUseCase _requestPermissionUseCase = getIt();
  late final GetNotificationsUseCase _getNotificationsUseCase = getIt();
  final List<NotificationEntity> _notifications = [];

  late final NotificationRemoteDataSource _notificationRemoteDataSource = getIt();

  final TextEditingController _subscribeController = TextEditingController();
  final TextEditingController _unsubscribeController = TextEditingController();
  final TextEditingController _sendToTopicController = TextEditingController();
  final TextEditingController _sendToTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _subscribeToNotifications();
    _getFcmToken();
  }

  String? token = "";

  void _getFcmToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');
    _sendToTokenController.text = token ?? "";
  }

  StreamSubscription? subscription;

  Future<void> _requestPermission() async {
    await _requestPermissionUseCase();
  }

  void _subscribeToNotifications() {
    subscription = _getNotificationsUseCase().listen((notification) {
      setState(() {
        _notifications.add(notification);
      });
    });
  }

  // void _sendTestNotification() {
  //   if (token != null) {
  //     _notificationRemoteDataSource.sendPushNotification(
  //       token: token!,
  //       title: "Test Notification",
  //       body: "This is a test notification.",
  //     );
  //   }
  // }

  void _subscribeToTopic() {
    final topic = _subscribeController.text.trim();
    if (topic.isNotEmpty) {
      FirebaseMessaging.instance.subscribeToTopic(topic);
      _subscribeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscribed to topic: $topic')),
      );
    }
  }

  void _unsubscribeFromTopic() {
    final topic = _unsubscribeController.text.trim();
    if (topic.isNotEmpty) {
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      _unsubscribeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsubscribed from topic: $topic')),
      );
    }
  }
  //
  // void _sendNotificationToTopic() {
  //   final topic = _sendToTopicController.text.trim();
  //   if (topic.isNotEmpty) {
  //     _notificationRemoteDataSource.sendPushNotification(
  //       topic: topic,
  //       title: "Notification for topic $topic",
  //       body: "This is a notification for topic $topic.",
  //     );
  //     _sendToTopicController.clear();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Notification sent to topic: $topic')),
  //     );
  //   }
  // }

  // void _sendNotificationToToken() {
  //   final targetToken = _sendToTokenController.text.trim();
  //   if (targetToken.isNotEmpty) {
  //     _notificationRemoteDataSource.sendPushNotification(
  //       token: targetToken,
  //       title: "Custom Notification",
  //       body: "This is a notification sent to a specific device.",
  //     );
  //     _sendToTokenController.clear();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Notification sent to the specified device.')),
  //     );
  //   }
  // }

  @override
  void dispose() {
    subscription?.cancel();
    _subscribeController.dispose();
    _unsubscribeController.dispose();
    _sendToTopicController.dispose();
    _sendToTokenController.dispose();
    super.dispose();
  }

  // void copy(){
  //   Clipboard.setData(ClipboardData(text: token ?? ""));
  //   showToast("Copied",position: ToastPosition.bottom);
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subscribeController,
                      decoration: InputDecoration(
                        labelText: 'Enter topic name to subscribe',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _subscribeToTopic,
                    child: Text('Subscribe'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _unsubscribeController,
                      decoration: InputDecoration(
                        labelText: 'Enter topic name to unsubscribe',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _unsubscribeFromTopic,
                    child: Text('Unsubscribe'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _sendToTopicController,
                      decoration: InputDecoration(
                        labelText: 'Enter topic name to send notification',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    // _sendNotificationToTopic,
                    child: Text('Send to Topic'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _sendToTokenController,
                      decoration: InputDecoration(
                        labelText: 'Enter token to send notification',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:(){},
                    // _sendNotificationToToken,
                    child: Text('Send to Token'),
                  ),
                ],
              ),
            ),
            Divider(),
            _notifications.isEmpty
                ? Center(child: Text('No notifications available'))
                : ListView.builder(
              shrinkWrap: true,
              reverse: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return NotificationWidget(
                    notification: _notifications[index]);
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: DefaultElevatedButton1(
      //           text: "copy my toke",
      //           onPressed: (){
      //             copy();
      //           },
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );

  }
}