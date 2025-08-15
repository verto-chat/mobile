import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';

part 'chat_message.g.dart';

enum MessageTypeDto {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('file')
  file,
}

@JsonSerializable()
class MessageDto {
  final MessageTypeDto type;
  final Map<String, dynamic> content;

  MessageDto(this.content, this.type);

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  Message toEntity() {
    return switch (type) {
      MessageTypeDto.text => TextMessageDto.fromJson(content).toEntity(),
      MessageTypeDto.image => ImageMessageDto.fromJson(content).toEntity(),
      MessageTypeDto.file => FileMessageDto.fromJson(content).toEntity(),
    };
  }
}

@JsonSerializable()
class ChatAuthorDto {
  final String id;
  final String? avatarUrl;
  final String? thumbnailAvatarUrl;
  final String firstName;
  final String? lastName;
  final bool isSupport;

  ChatAuthorDto(this.id, this.avatarUrl, this.thumbnailAvatarUrl, this.firstName, this.lastName, this.isSupport);

  factory ChatAuthorDto.fromJson(Map<String, dynamic> json) => _$ChatAuthorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAuthorDtoToJson(this);

  ChatUser toEntity() {
    return ChatUser(
      id: DomainId.fromString(id: id),
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      thumbnailAvatarUrl: thumbnailAvatarUrl,
      isSupport: isSupport,
    );
  }
}

@JsonSerializable()
class TextMessageDto {
  final String id;
  final DateTime createdAt;
  final ChatAuthorDto author;
  final String original;
  final String? translated;

  TextMessageDto(this.id, this.createdAt, this.author, this.original, this.translated);

  factory TextMessageDto.fromJson(Map<String, dynamic> json) => _$TextMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TextMessageDtoToJson(this);

  Message toEntity() {
    return TextMessage(
      id: id,
      text: translated ?? original,
      createdAt: createdAt,
      metadata: {"original": original, "hasTranslated": translated?.isNotEmpty ?? false, "user": author.toEntity()},
      authorId: author.id,
    );
  }
}

@JsonSerializable()
class ImageMessageDto {
  final String id;
  final DateTime createdAt;
  final ChatAuthorDto author;
  final String name;
  final String imageUrl;
  final String? thumbnailUrl;
  final int? size;

  ImageMessageDto(this.id, this.createdAt, this.author, this.name, this.imageUrl, this.thumbnailUrl, this.size);

  factory ImageMessageDto.fromJson(Map<String, dynamic> json) => _$ImageMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageMessageDtoToJson(this);

  Message toEntity() {
    return ImageMessage(
      id: id,
      authorId: author.id,
      createdAt: createdAt,
      source: thumbnailUrl ?? imageUrl,
      text: name,
      metadata: {"user": author.toEntity(), "size": size, "sourceImageUrl": imageUrl},
    );
  }
}

@JsonSerializable()
class FileMessageDto {
  final String id;
  final DateTime createdAt;
  final ChatAuthorDto author;
  final String name;
  final String url;
  final String mimeType;
  final int? size;

  FileMessageDto(this.id, this.createdAt, this.author, this.name, this.url, this.mimeType, this.size);

  factory FileMessageDto.fromJson(Map<String, dynamic> json) => _$FileMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FileMessageDtoToJson(this);

  Message toEntity() {
    return FileMessage(
      id: id,
      authorId: author.id,
      createdAt: createdAt,
      name: name,
      source: url,
      size: size,
      mimeType: mimeType,
      metadata: {"user": author.toEntity()},
    );
  }
}
