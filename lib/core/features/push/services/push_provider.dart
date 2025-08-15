import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../common/common.dart';
import '../data/models/models.dart';
import '../domain/domain.dart';
import '../presentation/presentation.dart';
import '../presentation/push_background_handler.dart';
import 'push_action_notificator.dart';

class PushProvider {
  final ILogger _logger;
  final LocalPushPresenter _localPushPresenter;
  final PushActionNotificator _pushActionNotificator;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  PushProvider(this._logger, this._localPushPresenter, this._pushActionNotificator) {
    _init();
  }

  Future<NotificationInfo?> getInitialMessage() async {
    final initMessage = await _messaging.getInitialMessage();

    if (initMessage == null) return null;

    _logger.log(LogLevel.info, "Initial push message data: ${initMessage.data}");

    return _getMessage(initMessage);
  }

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final _ = await FirebaseMessaging.instance.requestPermission(provisional: true);

        final apnsToken = await _messaging.getAPNSToken();

        if (apnsToken != null) {
          _logger.log(LogLevel.info, "APNs token: $apnsToken");
        }
      }

      return await _messaging.getToken();
    } catch (e) {
      _logger.log(LogLevel.error, "Getting FCM token error", exception: e);
      return null;
    }
  }

  void _init() {
    //NOTE: function which is called when the app is in the background or terminated
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //NOTE: function which is called when an incoming FCM payload is received whilst the Flutter instance is in the foreground.
    FirebaseMessaging.onMessage.listen((message) {
      _logger.log(LogLevel.info, "foreground push message data: ${message.data}");

      final body = message.notification?.body;

      if (body == null) return;

      _localPushPresenter.showNotification(
        title: message.notification?.title,
        body: body,
        payload: jsonEncode(message.data),
      );
    });

    //NOTE: function which is called when a user presses a notification message displayed via FCM.
    // A Stream event will be sent if the app has opened from a background state (not terminated).
    // If your app is opened via a notification whilst the app is terminated, see getInitialMessage.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _logger.log(LogLevel.info, "background push message data: ${message.data}");

      final notificationInfo = _getMessage(message);

      if (notificationInfo == null) return;

      _pushActionNotificator.notify(notificationInfo);
    });
  }

  NotificationInfo? _getMessage(RemoteMessage message) {
    try {
      final notification = NotificationDto.fromJson(message.data);
      final notificationInfo = getNotificationInfo(notification);

      return notificationInfo;
    } on Exception catch (e) {
      _logger.log(LogLevel.error, "Getting notification info error", exception: e);
    }

    return null;
  }
}
