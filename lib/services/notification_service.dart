

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('notification_icon');

  void initializeNotifications() async {
    InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(String title, String body) async {

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channelId', 'channelName',importance: Importance.max,priority: Priority.high);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails
    );

    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}