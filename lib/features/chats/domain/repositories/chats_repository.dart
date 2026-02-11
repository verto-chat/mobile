import 'package:flutter_chat_core/flutter_chat_core.dart';

import '../../../../common/common.dart';
import '../entities/entities.dart';

abstract interface class IChatsRepository {
  Stream<int> onChatsChanges(int offset);

  Future<DomainResultDErr<List<Chat>>> getChats(int limit, {DomainId? lastChatId});

  Stream<int> onMessagesChanges(DomainId chatId, int offset);

  Future<DomainResultDErr<ShortChatInfo>> getShortChatInfo(DomainId chatId);

  Future<DomainResultDErr<List<Message>>> getMessages(
    DomainId chatId,
    int limit, {
    required String Function(String authorId, String originalLanguageCode) resolveAuthor,
    DomainId? lastMessageId,
  });

  Future<EmptyDomainResult> sendMessage(DomainId chatId, String text);

  Future<EmptyDomainResult> sendVoiceMessage({
    required DomainId chatId,
    required String messageId,
    required String ttsStorageKey,
    required String originalLanguageCode,
    required String translatedLanguageCode,
  });

  Future<EmptyDomainResult> sendFileMessage(
    DomainId chatId, {
    required String name,
    required int size,
    required String fileUrl,
    String? mimeType,
  });

  Future<EmptyDomainResult> sendImageMessage(
    DomainId chatId, {
    required String name,
    required int size,
    required String imageUrl,
    required String thumbnailUrl,
  });

  Future<DomainResultDErr<String>> getTtsLink({required DomainId chatId, required String messageId});

  String getTtsStorageKey({required String languageCode, required DomainId chatId, required String messageId});
}
