import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart' hide FileType;
import '../../../report/report.dart';
import '../../domain/domain.dart';
import '../pages/select_attachment_type_sheet.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

const int _limit = 20;

class ChatBloc extends ContextBloc<ChatEvent, ChatState> {
  final ChatController _chatController = InMemoryChatController();

  final IChatsRepository _chatsRepository;
  final IUploadRepository _uploadRepository;
  final ILogger _logger;

  late final StreamSubscription<int> _subscription;
  late final DomainId _chatId;

  DomainId? _lastMessageId;

  bool _hasMore = true;
  bool _isLoading = false;

  ChatBloc(BuildContext context, this._chatsRepository, this._uploadRepository, this._logger)
    : super(const ChatState.notInitilized(), context) {
    on<_Started>(_onStarted);
    on<_Send>(_onSend);
    on<_OnEndReached>(_onOnEndReached);
    on<_AddAttachment>(_onAddAttachment);
    on<_TapMessage>(_onTapMessage);
    on<_LongTapMessage>(_onLongTapMessage);
    // on<_LoadPreview>(_onLoadPreview);
  }

  @override
  Future<void> close() async {
    _chatController.dispose();

    await _subscription.cancel();
    await super.close();
  }

  Future<void> _onStarted(_Started event, Emitter<ChatState> emit) async {
    _chatId = event.chatId;

    final result = await _chatsRepository.getShortChatInfo(_chatId, languageCode);

    switch (result) {
      case Success():
        emit(
          ChatState.initilized(
            chatController: _chatController,
            currentUserId: result.data.currentUserId.toString(),
            chatType: result.data.type,
            title: result.data.name,
            advertId: result.data.advertId,
          ),
        );

        _subscription = _chatsRepository
            .onMessagesChanges(_chatId, _limit)
            .listen(
              (count) {
                _hasMore = true;
                add(const ChatEvent.onEndReached(null));
              },
              onError: (dynamic error) {
                _hasMore = true;
                _logger.log(LogLevel.error, "Failed to get messages changes", exception: error);
                add(const ChatEvent.onEndReached(null));
              },
            );

      case Error():
        emit(const ChatState.failure());
    }
  }

  Future<void> _onOnEndReached(_OnEndReached event, Emitter<ChatState> emit) async {
    if (!_hasMore || _isLoading) {
      event.completer?.complete();
      return;
    }

    _isLoading = true;

    final result = await _chatsRepository.getMessages(
      _chatId,
      _limit,
      lastMessageId: event.completer != null ? _lastMessageId : null,
    );

    switch (result) {
      case Success():
        final newMessages = result.data.reversed.toList();

        if (newMessages.isEmpty) {
          _hasMore = false;
          _isLoading = false;
          event.completer?.complete();
          return;
        }

        await _chatController.setMessages(
          event.completer != null ? [...newMessages, ..._chatController.messages] : newMessages,
        );

        final lastMessage = newMessages.firstOrNull;

        _lastMessageId = lastMessage == null ? null : DomainId.fromString(id: lastMessage.id);
        _isLoading = false;

      case Error():
        emit(const ChatState.failure());
        showError(result.errorData);
    }

    event.completer?.complete();
  }

  Future<void> _onSend(_Send event, Emitter<ChatState> emit) async {
    if (state case Initilized initilizedState) {
      final Message message = TextMessage(
        id: const Uuid().v4(),
        authorId: initilizedState.currentUserId,
        text: event.text,
        metadata: {'sending': true},
      );

      _chatController.insertMessage(message);

      final result = await _chatsRepository.sendMessage(_chatId, event.text);

      switch (result) {
        case Success():
        //emit(initilizedState.copyWith(messages: [message.copyWith(status: Status.delivered), ...oldMessages]));
        case Error():
        //emit(initilizedState.copyWith(messages: [message.copyWith(status: Status.error), ...oldMessages]));
      }
    }
  }

  Future<void> _onTapMessage(_TapMessage event, Emitter<ChatState> emit) async {
    final message = event.message;

    if (message is FileMessage) {
      var localPath = message.source;

      if (localPath.startsWith('http')) {
        final updatedMessage = message.copyWith(metadata: {'sending': true});

        try {
          _chatController.updateMessage(message, updatedMessage);

          final dio = Dio();
          final response = await dio.get<List<int>>(localPath, options: Options(responseType: ResponseType.bytes));

          final bytes = response.data!;

          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          _chatController.updateMessage(updatedMessage, message);
        }
      }

      await OpenFilex.open(localPath);
    } else if (message is ImageMessage) {
      var localPath = message.metadata!['sourceImageUrl'] as String;

      showGallery(context, [localPath]);
    }
  }

  Future<void> _onAddAttachment(_AddAttachment event, Emitter<ChatState> emit) async {
    final result = await showModalBottomSheet<ChatAttachmentType>(
      context: context,
      builder: (BuildContext context) => const SelectAttachmentTypeSheet(),
    );

    if (result == null) return;

    switch (result) {
      case ChatAttachmentType.image:
        await _handleImageSelection(emit);
      case ChatAttachmentType.file:
        await _handleFileSelection(emit);
    }
  }

  Future<void> _handleFileSelection(Emitter<ChatState> emit) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      //_setAttachmentUploading(true, emit);

      final name = result.files.single.name;
      final filePath = result.files.single.path!;

      final uploadResult = await _uploadRepository.uploadChatFile(File(filePath));

      switch (uploadResult) {
        case Success():
          final _ = await _chatsRepository.sendFileMessage(
            _chatId,
            mimeType: lookupMimeType(filePath),
            name: name,
            size: result.files.single.size,
            fileUrl: uploadResult.data.fileUrl,
          );

        //_setAttachmentUploading(false, emit);
        case Error():
          //_setAttachmentUploading(false, emit);
          break;
      }
    }
  }

  Future<void> _handleImageSelection(Emitter<ChatState> emit) async {
    final result = await pickImages(context, isMultiselect: false);

    if (result.isNotEmpty) {
      //_setAttachmentUploading(true, emit);

      final pickedImage = result.first;

      final file = File(pickedImage.path);
      final size = file.lengthSync();
      final name = pickedImage.name;

      try {
        final uploadResult = await _uploadRepository.uploadChatImage(file);

        switch (uploadResult) {
          case Success():
            final _ = await _chatsRepository.sendImageMessage(
              _chatId,
              name: name,
              size: size,
              imageUrl: uploadResult.data.imageUrl,
              thumbnailUrl: uploadResult.data.thumbnailImageUrl,
            );

          case Error():
            break;
        }
      } finally {
        //_setAttachmentUploading(false, emit);
      }
    }
  }

  Future<void> _onLongTapMessage(_LongTapMessage event, Emitter<ChatState> emit) async {
    final state = this.state;

    if (state is! Initilized) return;

    if (event.message.authorId == state.currentUserId) return;

    final loc = appTexts.shop.detail.advert_detail_page.menu;

    final result = await showModalBottomSheet<_MenuAction>(
      context: context,
      builder: (BuildContext context) => SelectSheetContainer(
        children: [
          if (event.message.authorId != state.currentUserId) ...[
            CommonSelectTile.fromIcons(
              onTap: () => Navigator.pop(context, _MenuAction.report),
              icon: Icons.report,
              title: loc.report,
            ),
          ] else
            ...[],
        ],
      ),
    );

    if (result == null || !context.mounted) return;

    switch (result) {
      case _MenuAction.report:
        await _report(emit, DomainId.fromString(id: event.message.id));
    }
  }

  Future<void> _report(Emitter<ChatState> emit, DomainId messageId) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => ReportSheet(targetType: TargetType.chatMessage, targetId: messageId),
    );
  }
  // void _setAttachmentUploading(bool isAttachmentUploading, Emitter<ChatState> emit) {
  //   // if (state case Initilized initilizedState) {
  //   //   emit(initilizedState.copyWith(isAttachmentUploading: isAttachmentUploading));
  //   // }
  // }

  // Future<void> _onLoadPreview(_LoadPreview event, Emitter<ChatState> emit) async {
  //   final updatedMessage = event.message.copyWith(previewData: event.previewData);
  //
  //   _updateMessage(updatedMessage, emit);
  // }
}

enum _MenuAction { report }
