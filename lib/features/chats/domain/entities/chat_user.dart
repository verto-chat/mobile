import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'chat_user.freezed.dart';

const emptyChatUser = ChatUser(
  id: DomainId.fromInt(id: 0),
  firstName: '',
  lastName: null,
  avatarUrl: null,
  thumbnailAvatarUrl: null,
  isSupport: false,
);

@freezed
sealed class ChatUser with _$ChatUser {
  const factory ChatUser({
    required DomainId id,
    required String firstName,
    required String? lastName,
    required String? avatarUrl,
    required String? thumbnailAvatarUrl,
    required bool isSupport,
  }) = _ChatUser;
}

extension ChatUserExt on ChatUser {
  String? get thumbnail => thumbnailAvatarUrl ?? avatarUrl;
}
