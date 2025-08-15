import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'chat.freezed.dart';

typedef CreatedChat = ({String name, DomainId id});

enum ChatType { p2p, group, favorites, support }

@freezed
sealed class Chat with _$Chat {
  const factory Chat({
    required DomainId id,
    required ChatType type,
    required String? avatarUrl,
    required String? thumbnailAvatarUrl,
    required String? name,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) = _Chat;
}

extension ChatTypeExt on Chat {
  String? get thumbnail => thumbnailAvatarUrl ?? avatarUrl;
}
