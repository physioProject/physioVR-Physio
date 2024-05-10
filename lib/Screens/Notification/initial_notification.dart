import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'MessageDetails.dart';

class LocalNotificationServices {
  static String channelKey = 'basic_channel';
  static String channelGroupKey = 'basic_channel_group';
  static String channelName = 'Basic notifications';
  static String channelGroupName = 'Basic group';
  static String localTimeZone = '';

  ///initialize local notification ------------------------------------------------------------------------------------
  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: channelGroupKey,
            channelKey: channelKey,
            channelName: channelName,
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            criticalAlerts: true,
          )
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: channelGroupKey,
            channelGroupName: channelGroupName,
          )
        ],
        debug: true);
    localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    print('localTimeZone: $localTimeZone');
  }

  /// display notification ------------------------------------------------------------------------------------
  static showNotification(MessageDetails message) async {
    try {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: message.id,
            title: message.title,
            body: message.body,
            channelKey: channelKey,
            actionType: ActionType.Default,
            category: NotificationCategory.Reminder,
            wakeUpScreen: true,
            autoDismissible: false,
          ),
          schedule: NotificationCalendar(
            allowWhileIdle: true,
            preciseAlarm: true,
            hour: message.hour,
            minute: message.minute,
            timeZone: localTimeZone,
            repeats: message.repeats,
          ));
    } catch (e) {
      print('\x1B[33m Error in show notification: ${e.toString()}\x1B[0m');
    }
  }

  ///cancel notification===========================================
  static Future<void> cancelNotification(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId).then((value) {
      print('AwesomeNotifications cancel');
    });
  }
}
