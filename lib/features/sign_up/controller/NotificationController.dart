import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController {
  final storage = GetStorage();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print('Notification tapped: ${details.payload}');
      },
    );
  }

  Future<bool> requestNotificationPermission() async {
    try {
      if (GetPlatform.isIOS) {
        final status = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        savePermissionStatus(status ?? false);
        return status ?? false;
      }
      else if (GetPlatform.isAndroid) {
            final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        // for android 13+ it requires explicit permission request
        if (sdkInt >= 33) {
          // shows dialog
          await Future.delayed(Duration(milliseconds: 500));

          // this requests permission
          final status = await Permission.notification.request();
          final isGranted = status.isGranted;

          // sending a test notification if granted
          if (isGranted) {
            await sendTestNotification();
          }

          savePermissionStatus(isGranted);
          return isGranted;
        } else {
          // and for android < 13 permissions are granted at install time
          savePermissionStatus(true);
          await sendTestNotification();
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error requesting notification permission: $e');
      savePermissionStatus(false);
      return false;
    }
  }

  Future<void> sendTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'blott_channel_Id',
        'blotNotificationsChannel',
        channelDescription: 'For app notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Welcome to Blott! 😊🤗',
        'We promise to keep you informed on all news activities',
        platformDetails,
        payload: 'welcome',
      );
    } catch (e) {
      print('Error sending test notification: $e');
    }
  }

  void savePermissionStatus(bool isGranted) {
    storage.write('hasGrantedNotifications', isGranted);
  }

  Future<bool> checkNotificationPermission() async {
    if (GetPlatform.isIOS) {
      return storage.read('hasGrantedNotifications') ?? false;
    } else if (GetPlatform.isAndroid) {
      try {
        return await Permission.notification.isGranted;
      } catch (e) {
        return storage.read('hasGrantedNotifications') ?? false;
      }
    }
    return false;
  }
}

