import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'chat.freezed.dart';

typedef CreatedChat = ({String name, DomainId id});

enum ChatType { direct, group, local, learning }

@freezed
sealed class ChatLanguage with _$ChatLanguage {
  const factory ChatLanguage({required String languageCode, required bool isDefault}) = _ChatLanguage;
}

final emptyChat = Chat(
  id: const DomainId.fromInt(id: 0),
  type: ChatType.direct,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  languages: const [],
  avatarUrl: null,
  thumbnailAvatarUrl: null,
  name: null,
);

@freezed
sealed class Chat with _$Chat {
  const factory Chat({
    required DomainId id,
    required ChatType type,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<ChatLanguage>? languages,
    required String? avatarUrl,
    required String? thumbnailAvatarUrl,
    required String? name,
  }) = _Chat;
}

extension ChatTypeExt on Chat {
  String? get thumbnail => thumbnailAvatarUrl ?? avatarUrl;
}
