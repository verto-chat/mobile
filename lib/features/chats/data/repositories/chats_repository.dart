import 'package:flutter_chat_core/flutter_chat_core.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../data_sources/data_sources.dart';
import '../models/models.dart';
import '../supabase/supabase.dart';

class ChatsRepository implements IChatsRepository {
  final RealtimeChatsApi _supabaseChatsApi;
  final ChatsApi _chatsApi;
  final ChatMessagesApi _chatMessagesApi;
  final SafeDio _safeDio;
  final ILogger _logger;

  ChatsRepository(this._supabaseChatsApi, this._logger, this._chatsApi, this._chatMessagesApi, this._safeDio);

  @override
  Stream<int> onChatsChanges(int offset) {
    try {
      return _supabaseChatsApi.onChatsChanges(limit: offset).map((data) => data.length);
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to get chats changes", exception: e);
      rethrow;
    }
  }

  @override
  Future<DomainResultDErr<List<Chat>>> getChats(int limit, String locale, {DomainId? lastChatId}) async {
    final apiResult = await _safeDio.execute(() => _chatsApi.getChats(limit, lastChatId: lastChatId?.toString()));

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.map((d) => d.toEntity()).toList()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<DomainResultDErr<List<Chat>>> getAdvertChats(
    int offset,
    String locale,
    DomainId advertId, {
    DomainId? lastChatId,
  }) async {
    final apiResult = await _safeDio.execute(
      () => _chatsApi.getAdvertChats(offset, advertId.toString(), lastChatId: lastChatId?.toString()),
    );

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.map((d) => d.toEntity()).toList()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Stream<int> onMessagesChanges(DomainId chatId, int offset) {
    try {
      return _supabaseChatsApi.onMessagesChanges(chatId: chatId.toString(), limit: offset).map((docs) => docs.length);
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to get messages changes", exception: e);
      rethrow;
    }
  }

  @override
  Future<DomainResultDErr<ShortChatInfo>> getShortChatInfo(DomainId chatId, String languageCode) async {
    final apiResult = await _safeDio.execute(() => _chatsApi.getShortChatInfo(chatId.toString()));

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.toEntity()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<DomainResultDErr<List<Message>>> getMessages(DomainId chatId, int limit, {DomainId? lastMessageId}) async {
    final apiResult = await _safeDio.execute(
      () => _chatMessagesApi.getMessages(chatId.toString(), limit, lastMessageId: lastMessageId?.toString()),
    );

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.map((d) => d.toEntity()).toList()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<DomainResultDErr<CreatedChat>> createDirectChat(UserInfo user) async {
    final apiResult = await _safeDio.execute(() => _chatsApi.createDirectChat(user.id.toString()));

    return switch (apiResult) {
      ApiSuccess(:final data) => Success(data: (id: DomainId.fromString(id: data.id), name: data.name)),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> sendMessage(DomainId chatId, String message) async {
    final request = SendTextMessageRequestDto(chatId: chatId.toString(), originalText: message);

    final apiResult = await _safeDio.execute(() => _chatMessagesApi.sendTextMessage(request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> sendFileMessage(
    DomainId chatId, {
    required String name,
    required int size,
    required String fileUrl,
    String? mimeType,
  }) async {
    final request = SendFileMessageRequestDto(
      chatId: chatId.toString(),
      fileUrl: fileUrl,
      fileName: name,
      fileSize: size,
      mimeType: mimeType,
    );

    final apiResult = await _safeDio.execute(() => _chatMessagesApi.sendFileMessage(request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> sendImageMessage(
    DomainId chatId, {
    required String name,
    required int size,
    required String imageUrl,
    required String thumbnailUrl,
  }) async {
    final request = SendImageMessageRequestDto(
      chatId: chatId.toString(),
      imageUrl: imageUrl,
      thumbnailImageUrl: thumbnailUrl,
      fileName: name,
      fileSize: size,
    );

    final apiResult = await _safeDio.execute(() => _chatMessagesApi.sendImageMessage(request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<DomainResultDErr<CreatedChat>> createSupportChat() async {
    final apiResult = await _safeDio.execute(() => _chatsApi.createSupportChat());

    return switch (apiResult) {
      ApiSuccess(:final data) => Success(data: (id: DomainId.fromString(id: data.id), name: data.name)),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }
}
