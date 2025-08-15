import 'package:json_annotation/json_annotation.dart';

import '../../../../common/common.dart';
import '../../domain/entities/entities.dart';

part 'chat_dto.g.dart';

@JsonSerializable()
class CreateChatResponseDto {
  final String id;
  final String name;

  CreateChatResponseDto({required this.id, required this.name});

  factory CreateChatResponseDto.fromJson(Map<String, dynamic> json) => _$CreateChatResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatResponseDtoToJson(this);
}

enum ChatTypeDto {
  @JsonValue('direct')
  p2p,
  @JsonValue('group')
  group,
  @JsonValue('support')
  support,
  @JsonValue('favorites')
  favorites;

  ChatType toEntity() {
    return switch (this) {
      ChatTypeDto.p2p => ChatType.p2p,
      ChatTypeDto.group => ChatType.group,
      ChatTypeDto.favorites => ChatType.favorites,
      ChatTypeDto.support => ChatType.support,
    };
  }
}

@JsonSerializable()
class ChatDto {
  final String id;
  final String? name;
  final String? avatarUrl;
  final String? thumbnailAvatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatTypeDto type;

  ChatDto(this.id, this.name, this.avatarUrl, this.thumbnailAvatarUrl, this.createdAt, this.updatedAt, this.type);

  Chat toEntity() {
    return Chat(
      id: DomainId.fromString(id: id),
      avatarUrl: avatarUrl,
      thumbnailAvatarUrl: thumbnailAvatarUrl,
      name: name,
      type: type.toEntity(),
      createdAt: createdAt.toLocal(),
      updatedAt: updatedAt.toLocal(),
    );
  }

  factory ChatDto.fromJson(Map<String, dynamic> json) => _$ChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);
}
