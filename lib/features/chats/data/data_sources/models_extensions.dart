import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:openapi/openapi.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';

extension ChatLanguageDtoExtensions on ChatLanguageDto {
  ChatLanguage toEntity() => ChatLanguage(languageCode: languageCode.toStringCode(), isDefault: isDefault);
}

extension ChatDtoExtensions on ChatDto {
  Chat toEntity() {
    return Chat(
      id: DomainId.fromString(id: id),
      avatarUrl: avatarUrl,
      thumbnailAvatarUrl: thumbnailAvatarUrl,
      name: name,
      type: type.toEntity(),
      createdAt: createdAt.toLocal(),
      updatedAt: updatedAt.toLocal(),
      languages: languages.map((e) => e.toEntity()).toList(),
    );
  }
}

extension MessageDtoExtensions on MessageDto {
  Message toEntity(String Function(String authorId, String originalLanguageCode) resolveAuthor) {
    return switch (type) {
      MessageTypeDto.text => MessageContentDtoTextMessageContentDto.fromJson(content).toEntity(resolveAuthor),
      MessageTypeDto.image => MessageContentDtoImageMessageContentDto.fromJson(content).toEntity(),
      MessageTypeDto.file => MessageContentDtoFileMessageContentDto.fromJson(content).toEntity(),
    };
  }
}

extension ChatAuthorDtoExtensions on ChatAuthorDto {
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

extension TextMessageDtoExtensions on MessageContentDtoTextMessageContentDto {
  Message toEntity(String Function(String authorId, String originalLanguageCode) resolveAuthor) {
    final originalLanguageCode = this.originalLanguageCode.toStringCode();

    return TextMessage(
      id: id,
      text: translated ?? original,
      createdAt: createdAt,
      metadata: TextMessageMetadata(
        original: original,
        hasTranslated: translated?.isNotEmpty ?? false,
        user: author.toEntity(),
        originalLanguageCode: originalLanguageCode,
        translatedLanguageCode: translatedLanguageCode?.toStringCode(),
      ).toJson(),
      authorId: resolveAuthor(author.id, originalLanguageCode),
    );
  }
}

extension ImageMessageDtoExtensions on MessageContentDtoImageMessageContentDto {
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

extension FileMessageDtoExtensions on MessageContentDtoFileMessageContentDto {
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

extension ChatTypeDtoExtensions on ChatTypeDto {
  ChatType toEntity() => switch (this) {
    ChatTypeDto.direct => ChatType.direct,
    ChatTypeDto.group => ChatType.group,
    ChatTypeDto.local => ChatType.local,
    ChatTypeDto.support => ChatType.learning,
  };
}

extension ShortChatInfoDtoExtensions on ChatDetailDto {
  ShortChatInfo toEntity() {
    return ShortChatInfo(
      id: DomainId.fromString(id: id),
      name: name,
      type: type.toEntity(),
      currentUserId: DomainId.fromString(id: currentUserId),
      avatarUrl: avatarUrl,
      thumbnailAvatarUrl: thumbnailAvatarUrl,
      createdAt: createdAt.toLocal(),
      updatedAt: updatedAt.toLocal(),
      languages: languages.map((e) => e.toEntity()).toList(),
    );
  }
}

extension LanguageDtoExtensions on String {
  LanguageCode toLanguageCode() => switch (this) {
    "ar" => LanguageCode.ar,
    "be" => LanguageCode.be,
    "bg" => LanguageCode.bg,
    "ca" => LanguageCode.ca,
    "cs" => LanguageCode.cs,
    "de" => LanguageCode.de,
    "en" => LanguageCode.en,
    "es" => LanguageCode.es,
    "fa" => LanguageCode.fa,
    "fi" => LanguageCode.fi,
    "fr" => LanguageCode.fr,
    "he" => LanguageCode.he,
    "hr" => LanguageCode.hr,
    "hu" => LanguageCode.hu,
    "id" => LanguageCode.id,
    "it" => LanguageCode.it,
    "kk" => LanguageCode.kk,
    "ko" => LanguageCode.ko,
    "ms" => LanguageCode.ms,
    "nb" => LanguageCode.nb,
    "nl" => LanguageCode.nl,
    "pl" => LanguageCode.pl,
    "pt" => LanguageCode.pt,
    "ro" => LanguageCode.ro,
    "ru" => LanguageCode.ru,
    "sk" => LanguageCode.sk,
    "sr" => LanguageCode.sr,
    "sv" => LanguageCode.sv,
    "tr" => LanguageCode.tr,
    "uk" => LanguageCode.uk,
    "uz" => LanguageCode.uz,
    "vi" => LanguageCode.vi,
    "zh" => LanguageCode.zh,

    _ => LanguageCode.en,
  };
}

extension LanguageCodeExtensions on LanguageCode {
  String toStringCode() => name;

  String toStringCode2() => switch (this) {
    LanguageCode.ar => throw UnimplementedError(),
    LanguageCode.be => throw UnimplementedError(),
    LanguageCode.bg => throw UnimplementedError(),
    LanguageCode.ca => throw UnimplementedError(),
    LanguageCode.cs => throw UnimplementedError(),
    LanguageCode.de => throw UnimplementedError(),
    LanguageCode.en => throw UnimplementedError(),
    LanguageCode.es => throw UnimplementedError(),
    LanguageCode.fa => throw UnimplementedError(),
    LanguageCode.fi => throw UnimplementedError(),
    LanguageCode.fr => throw UnimplementedError(),
    LanguageCode.he => throw UnimplementedError(),
    LanguageCode.hr => throw UnimplementedError(),
    LanguageCode.hu => throw UnimplementedError(),
    LanguageCode.id => throw UnimplementedError(),
    LanguageCode.it => throw UnimplementedError(),
    LanguageCode.kk => throw UnimplementedError(),
    LanguageCode.ko => throw UnimplementedError(),
    LanguageCode.ms => throw UnimplementedError(),
    LanguageCode.nb => throw UnimplementedError(),
    LanguageCode.nl => throw UnimplementedError(),
    LanguageCode.pl => throw UnimplementedError(),
    LanguageCode.pt => throw UnimplementedError(),
    LanguageCode.ro => throw UnimplementedError(),
    LanguageCode.ru => throw UnimplementedError(),
    LanguageCode.sk => throw UnimplementedError(),
    LanguageCode.sr => throw UnimplementedError(),
    LanguageCode.sv => throw UnimplementedError(),
    LanguageCode.tr => throw UnimplementedError(),
    LanguageCode.uk => throw UnimplementedError(),
    LanguageCode.uz => throw UnimplementedError(),
    LanguageCode.vi => throw UnimplementedError(),
    LanguageCode.zh => throw UnimplementedError(),
  };
}
