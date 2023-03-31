

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

//Notification Initialized Instance

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationServices{

  //initialized a android setting
  final AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('notification_icon');
  //initialized ios settings
  final DarwinInitializationSettings iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true
  );

  // Both the settings combine and making one initializationSetting
  void initializedSettings() async {
    initializeTimeZones();
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings
    );
    
    bool? initialized = await notificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (response){
      log(response.payload.toString());
    });

    log("Notifiacations: $initialized");
  }

  static void showNotification(String title, String body) async {
    //Notification Details for android
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
        "notifications-note",
        "Note Notifications",
      priority: Priority.max,
      importance: Importance.max
    );

    //Notification Details for ios
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );

    //combine Notification Details
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails
    );

    DateTime scheduledDate = DateTime.now().add(const Duration(seconds: 5));
    //plugin for notifications
    //await notificationsPlugin.show(0, title, body, notificationDetails);
    //await notificationsPlugin.schedule(0, title, body, scheduledDate, notificationDetails);
    await notificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        TZDateTime.from(scheduledDate, local),
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
      payload: ""
    );
    //notificationsPlugin.cancel(0);
  }

  void checkForNotification() async {
    NotificationAppLaunchDetails? details = await notificationsPlugin.getNotificationAppLaunchDetails();

    if(details != null){
      if(details.didNotificationLaunchApp){
        NotificationResponse? response = details.notificationResponse;

        if(response != null){
          String? payload = response.payload;
          log("Notification payload: $payload");
        }
      }
    }
  }
}