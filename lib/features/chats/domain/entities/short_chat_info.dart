import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../domain.dart';

part 'short_chat_info.freezed.dart';

@freezed
sealed class ShortChatInfo with _$ShortChatInfo {
  const factory ShortChatInfo({
    required DomainId id,
    required String? name,
    required ChatType type,
    required DomainId currentUserId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<ChatLanguage> languages,
    required String? avatarUrl,
    required String? thumbnailAvatarUrl,
  }) = _ShortChatInfo;
}
