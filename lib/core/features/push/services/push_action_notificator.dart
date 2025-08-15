import 'dart:async';

import '../domain/domain.dart';

class PushActionNotificator {
  final StreamController<NotificationInfo> _onNotificationActionRequest =
      StreamController<NotificationInfo>.broadcast();

  Stream<NotificationInfo> get onNotificationAction => _onNotificationActionRequest.stream;

  void notify(NotificationInfo info) => _onNotificationActionRequest.add(info);
}
