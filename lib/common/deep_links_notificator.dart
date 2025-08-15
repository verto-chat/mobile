import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'deep_links_notificator.freezed.dart';

@freezed
sealed class DeepLinkInfo with _$DeepLinkInfo {
  const factory DeepLinkInfo({required String url}) = _NotificationInfo;
}

class DeepLinksNotificator {
  final StreamController<DeepLinkInfo> _onNotificationActionRequest = StreamController<DeepLinkInfo>.broadcast();

  Stream<DeepLinkInfo> get onNotificationAction => _onNotificationActionRequest.stream;

  void notify(DeepLinkInfo info) => _onNotificationActionRequest.add(info);
}
