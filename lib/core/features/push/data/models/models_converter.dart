import '../../../../../common/common.dart';
import '../../domain/domain.dart';
import 'notification_dto.dart';

NotificationInfo getNotificationInfo(NotificationDto data) {
  return NotificationInfo(
    chatId: data.chatId != null ? DomainId.fromString(id: data.chatId!) : null,
    navigationType: _getAction(data.navigationType),
  );
}

AppNavigationAction? _getAction(AppNavigationActionDto? action) {
  if (action == null) return null;

  return switch (action) {
    AppNavigationActionDto.chat => AppNavigationAction.chat,
    AppNavigationActionDto.unknown => AppNavigationAction.unknown,
  };
}
