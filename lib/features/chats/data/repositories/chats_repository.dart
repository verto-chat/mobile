import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:openapi/openapi.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';
import '../data_sources/models_extensions.dart';
import '../supabase/supabase.dart';

class ChatsRepository implements IChatsRepository {
  final RealtimeChatsApi _supabaseChatsApi;
  final ChatsApi _chatsApi;
  final ChatMessagesApi _chatMessagesApi;
  final SafeDio _safeDio;
  final ILogger _logger;

  ChatsRepository(this._supabaseChatsApi, this._logger, this._chatsApi, this._chatMessagesApi, this._safeDio);

  void dispose() {
    _supabaseChatsApi.dispose();
  }

  @override
  Stream<int> onChatsChanges(int offset) {
    try {
      return _supabaseChatsApi.chatsChangesStream.map((data) => 0);
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to get chats changes", exception: e);
      rethrow;
    }
  }

  @override
  Future<DomainResultDErr<List<Chat>>> getChats(int limit, {DomainId? lastChatId}) async {
    final apiResult = await _safeDio.execute(
      () => _chatsApi.getChats(limit: limit, lastChatId: lastChatId?.toString()),
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
  Future<DomainResultDErr<ShortChatInfo>> getShortChatInfo(DomainId chatId) async {
    final apiResult = await _safeDio.execute(() => _chatsApi.getChatDetail(chatId: chatId.toString()));

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.toEntity()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<DomainResultDErr<List<Message>>> getMessages(
    DomainId chatId,
    int limit, {
    required String Function(String authorId, String originalLanguageCode) resolveAuthor,
    DomainId? lastMessageId,
  }) async {
    final apiResult = await _safeDio.execute(
      () => _chatMessagesApi.getMessages(
        chatId: chatId.toString(),
        limit: limit,
        lastMessageId: lastMessageId?.toString(),
      ),
    );

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.map((d) => d.toEntity(resolveAuthor)).toList()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> sendMessage(DomainId chatId, String message) async {
    final request = SendTextMessageRequestDto(chatId: chatId.toString(), originalText: message);

    final apiResult = await _safeDio.execute(
      () => _chatMessagesApi.sendTextMessage(sendTextMessageRequestDto: request),
    );

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> sendVoiceMessage({
    required DomainId chatId,
    required String messageId,
    required String ttsStorageKey,
    required String originalLanguageCode,
    required String translatedLanguageCode,
  }) async {
    final request = SendVoiceMessageRequestDto(
      chatId: chatId.toString(),
      messageId: messageId,
      ttsStorageKey: ttsStorageKey,
      originalLanguageCode: originalLanguageCode.toLanguageCode(),
      translatedLanguageCode: translatedLanguageCode.toLanguageCode(),
    );

    final apiResult = await _safeDio.execute(
      () => _chatMessagesApi.sendVoiceMessage(sendVoiceMessageRequestDto: request),
    );

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

    final apiResult = await _safeDio.execute(
      () => _chatMessagesApi.sendFileMessage(sendFileMessageRequestDto: request),
    );

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
      mimeType: null,
    );

    final apiResult = await _safeDio.execute(
      () => _chatMessagesApi.sendImageMessage(sendImageMessageRequestDto: request),
    );

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<DomainResultDErr<String>> getTtsLink({required DomainId chatId, required String messageId}) async {
    final request = TtsLinkRequestDto(chatId: chatId.toString(), messageId: messageId, isTranslatedVoice: true);

    final apiResult = await _safeDio.execute(() => _chatMessagesApi.getTtsLink(ttsLinkRequestDto: request));

    return switch (apiResult) {
      ApiSuccess(:final data) => Success(data: data.url),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  String getTtsStorageKey({required String languageCode, required DomainId chatId, required String messageId}) {
    return "tts/${chatId.toString()}/${messageId}_$languageCode.mp3";
  }
}
