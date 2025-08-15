import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../common/common.dart';

part 'notification_info.freezed.dart';

@freezed
sealed class NotificationInfo with _$NotificationInfo {
  const factory NotificationInfo({required DomainId? chatId, AppNavigationAction? navigationType}) = _NotificationInfo;
}

enum AppNavigationAction { chat, unknown }
