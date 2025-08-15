import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/splash_screen/controller/splash_controller.dart';

class NotificationServices {
  static FirebaseMessaging? messaging;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static bool notificationVisit = false;
  static SplashScreenController splashScreenController = Get.find<SplashScreenController>();

  ///--------------- In Main Screen ---------------///
  static Future<void> backgroundNotification(RemoteMessage message) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log("Setting :: $settings");
    log('Got a message!');
    log('Message data :: ${message.data}');

    if (message.notification != null) {
      log('Message Contained a Notification :: ${message.notification?.body}');
    }

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
    );

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '0',
      'story_box',
      channelDescription: 'hello',
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    if (message.notification != null && !kIsWeb) {
      // if (Preference.notification == true) {
      await flutterLocalNotificationsPlugin?.show(
        message.hashCode,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        platformChannelSpecifics,
        payload: 'Custom_Sound',
      );
    }
    // else {
    //     log("Notification Permission not allowed");
    //   }
    // }
    else {
      log('Handling background notification :: ${message.data}');
    }
  }

  ///imGE SGOW BAKI
  ///--------------- In Splash Screen ---------------///
  static initFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log("Setting :: $settings");
    await messaging.getToken().then((value) {
      log("This is FCM token :: $value");
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log("NotificationVisit with start :: $notificationVisit");
      notificationVisit = !notificationVisit;
      log("NotificationVisit with SetState :: $notificationVisit");

      // if (Preference.notification == true) {
      handleMessage(initialMessage);
      // } else {
      //   log("Notification Permission not allowed");
      // }

      // splashScreenController.update([Constant.idNotification]);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log("This is event log :: $event");
      // if (Preference.notification == true) {
      handleMessage(event);
      // } else {
      //   log("Notification Permission not allowed");
      // }
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data :: ${message.data}');

        if (message.notification != null) {
          log('Message also contained a notification :: ${message.notification}');
        }
        const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin?.initialize(const InitializationSettings(android: initializationSettingsAndroid),
            onDidReceiveNotificationResponse: (payload) {
          log("payload is:- $payload");

          // if (Preference.notification == true) {
          handleMessage(message);
          // } else {
          //   log("Notification Permission not allowed");
          // }
        });

        // if (Preference.notification == true) {
        showNotificationWithSound(message);
        // } else {
        //   log("Notification Permission not allowed");
        // }
      },
    );
  }

  static Future<void> handleMessage(RemoteMessage message) async {
    // if (message.data.isEmpty) {
    //   Get.toNamed(AppRoutes.notification);
    // } else {
    //   id = message.data["senderId"];
    //
    //   Get.toNamed(
    //     AppRoutes.personalChat,
    //     arguments: [
    //       message.data["senderId"],
    //       message.data["chatTopic"],
    //       message.data["senderName"],
    //       message.data["senderImage"],
    //       message.data["designation"],
    //     ],
    //   )?.then((value) {
    //     id = '';
    //     log("Id for notification :: $id");
    //   });
    // }
  }

  static Future showNotificationWithSound(RemoteMessage message) async {
    log("Enter showNotificationWithSound");

    log("message.notification?.title :: ${message.notification?.title}");
    log("message.notification?.body :: ${message.notification?.body}");
    log("message.notification :: ${message.data}");
    log("message.notification :: ${message.data["image"]}");

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '0',
      "story_box",
      channelDescription: 'hello',
      icon: 'mipmap/ic_launcher',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin?.show(
      message.hashCode,
      message.notification?.title.toString(),
      message.notification?.body.toString(),
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }
}
