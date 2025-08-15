import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../common/common.dart';
import '../../../core.dart';
import '../data/models/models.dart';

class LocalPushPresenter {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  final ILogger _logger;
  final PushActionNotificator _pushActionNotificator;

  LocalPushPresenter(this._logger, this._pushActionNotificator);

  Future<void> setup() async {
    var settings = const InitializationSettings(
      iOS: DarwinInitializationSettings(),
      android: AndroidInitializationSettings("ic_push"),
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) => _onAction(notificationResponse.payload),
    );

    var details = await _localNotifications.getNotificationAppLaunchDetails();

    if (details == null) return;

    if (details.didNotificationLaunchApp) {
      _onAction(details.notificationResponse?.payload);
    }
  }

  Future<void> showNotification({required String? title, required String body, required String payload}) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "com.ovdix.firebase_push_notification",
        "notification channel",
        importance: Importance.max,
        priority: Priority.max,
        color: const Color(0xFFD95D19),
        styleInformation: BigTextStyleInformation(body),
        icon: 'ic_push',
      ),
    );

    var id = DateTime.now().hashCode;

    _logger.log(LogLevel.info, "Started showing push: id:$id");

    await _localNotifications.show(id, title, body, notificationDetails, payload: payload);

    _logger.log(LogLevel.info, "Ended showing push: id:$id");
  }

  void _onAction(String? payload) {
    if (payload == null || payload.isEmpty) {
      _logger.log(LogLevel.warning, "Push payload is null or empty");
      return;
    }

    try {
      var notification = NotificationDto.fromJson(jsonDecode(payload) as Map<String, dynamic>);

      _pushActionNotificator.notify(getNotificationInfo(notification));
    } on Exception catch (e) {
      _logger.log(LogLevel.error, "Getting push error", exception: e);
    }
  }
}
