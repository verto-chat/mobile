import 'package:flutter_chat_core/flutter_chat_core.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';

abstract interface class IChatsRepository {
  Stream<int> onChatsChanges(int offset);

  Future<DomainResultDErr<List<Chat>>> getChats(int limit, String locale, {DomainId? lastChatId});

  Future<DomainResultDErr<List<Chat>>> getAdvertChats(
    int offset,
    String locale,
    DomainId advertId, {
    DomainId? lastChatId,
  });

  Future<DomainResultDErr<CreatedChat>> createDirectChat(UserInfo user);

  Stream<int> onMessagesChanges(DomainId chatId, int offset);

  Future<DomainResultDErr<ShortChatInfo>> getShortChatInfo(DomainId chatId, String languageCode);

  Future<DomainResultDErr<List<Message>>> getMessages(DomainId chatId, int limit, {DomainId? lastMessageId});

  Future<EmptyDomainResult> sendMessage(DomainId chatId, String text);

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

  Future<DomainResultDErr<CreatedChat>> createSupportChat();
}
