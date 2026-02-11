import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flyer_chat_file_message/flyer_chat_file_message.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/entities/entities.dart' hide Chat;
import '../../voice/voice.dart';
import '../manager/chat_bloc.dart';
import 'widgets.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key, required this.state});

  final Initilized state;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.chats.chat_page;

    return Chat(
      theme: ChatTheme.fromThemeData(Theme.of(context)),
      currentUserId: state.chat.currentUserId.toString(),
      chatController: state.chatController,
      resolveUser: (id) async => null,
      onMessageSend: (text) => context.read<ChatBloc>().add(ChatEvent.send(text: text)),
      onMessageLongPress: (_, message, {LongPressStartDetails? details, int? index}) =>
          context.read<ChatBloc>().add(ChatEvent.longTapMessage(message)),
      onMessageTap: (_, message, {int? index, TapUpDetails? details}) =>
          context.read<ChatBloc>().add(ChatEvent.tapMessage(message)),
      onAttachmentTap: () => context.read<ChatBloc>().add(const ChatEvent.addAttachment()),
      builders: Builders(
        chatAnimatedListBuilder: (context, itemBuilder) {
          return ChatAnimatedListReversed(
            itemBuilder: itemBuilder,
            onEndReached: () {
              final completer = Completer<void>();

              context.read<ChatBloc>().add(ChatEvent.onEndReached(completer));

              return completer.future;
            },
          );
        },
        textMessageBuilder: (context, message, index, {required bool isSentByMe, MessageGroupStatus? groupStatus}) {
          return CustomTextMessage(
            message: message,
            index: index,
            onPlayTts: (message, {String? text, String? lang}) async {
              Completer<void> completer = Completer<void>();

              context.read<ChatBloc>().add(ChatEvent.playTts(message.id, completer: completer));

              await completer.future;
            },
          );
        },
        chatMessageBuilder:
            (
              context,
              message,
              index,
              animation,
              child, {
              bool? isRemoved,
              required bool isSentByMe,
              MessageGroupStatus? groupStatus,
            }) {
              return state.chat.type == ChatType.local
                  ? _localChatMessageBuilder(
                      context,
                      message,
                      index,
                      animation,
                      child,
                      isRemoved: isRemoved,
                      groupStatus: groupStatus,
                    )
                  : _chatMessageBuilder(
                      context,
                      message,
                      index,
                      animation,
                      child,
                      isRemoved: isRemoved,
                      groupStatus: groupStatus,
                      currentUserId: state.chat.currentUserId,
                      chatType: state.chat.type,
                    );
            },
        composerBuilder: (context) => _composerBuilder(context),
        imageMessageBuilder: (context, message, index, {required bool isSentByMe, MessageGroupStatus? groupStatus}) =>
            FlyerChatImageMessage(message: message, index: index),
        fileMessageBuilder: (context, message, index, {required bool isSentByMe, MessageGroupStatus? groupStatus}) =>
            FlyerChatFileMessage(message: message, index: index),
        emptyChatListBuilder: (context) => Center(child: Text(loc.no_messages_yet)),
      ),
    );
  }

  Widget _chatMessageBuilder(
    BuildContext context,
    Message message,
    int index,
    Animation<double> animation,
    Widget child, {
    bool? isRemoved,
    MessageGroupStatus? groupStatus,
    required DomainId currentUserId,
    required ChatType chatType,
  }) {
    final isSystemMessage = message.authorId == 'system';
    final isLastInGroup = groupStatus?.isLast ?? true;
    final shouldShowAvatar = !isSystemMessage && isLastInGroup && isRemoved != true;
    final isCurrentUser = message.authorId == currentUserId.toString();

    Widget? avatar = _avatarBuilder(
      shouldShowAvatar: shouldShowAvatar,
      message: message,
      isSystemMessage: isSystemMessage,
      chatType: chatType,
    );

    return ChatMessage(
      message: message,
      index: index,
      animation: animation,
      groupStatus: groupStatus,
      leadingWidget: !isCurrentUser
          ? avatar
          : isSystemMessage
          ? null
          : const SizedBox(width: 40),
      receivedMessageScaleAnimationAlignment: (message is SystemMessage) ? Alignment.center : Alignment.centerLeft,
      receivedMessageAlignment: (message is SystemMessage)
          ? AlignmentDirectional.center
          : AlignmentDirectional.centerStart,
      horizontalPadding: (message is SystemMessage) ? 0 : 8,
      child: child,
    );
  }

  Widget _localChatMessageBuilder(
    BuildContext context,
    Message message,
    int index,
    Animation<double> animation,
    Widget child, {
    bool? isRemoved,
    MessageGroupStatus? groupStatus,
  }) {
    final isSystemMessage = message.authorId == 'system';
    final isLastInGroup = groupStatus?.isLast ?? true;
    final shouldShowAvatar = !isSystemMessage && isLastInGroup && isRemoved != true;

    final messageMetadata = TextMessageMetadata.fromJson(message.metadata!);

    final secondLanguage = state.chat.languages.firstWhere((element) => !element.isDefault).languageCode;

    final isSecondLanguage = messageMetadata.originalLanguageCode == secondLanguage;

    Widget? avatar = _localChatAvatarBuilder(
      context: context,
      shouldShowAvatar: shouldShowAvatar,
      message: message,
      isSystemMessage: isSystemMessage,
      languageCode: messageMetadata.originalLanguageCode,
    );

    return ChatMessage(
      message: message,
      index: index,
      animation: animation,
      groupStatus: groupStatus,
      leadingWidget: isSystemMessage || isSecondLanguage ? null : avatar,
      trailingWidget: isSystemMessage || !isSecondLanguage ? null : avatar,
      receivedMessageScaleAnimationAlignment: (message is SystemMessage) ? Alignment.center : Alignment.centerLeft,
      receivedMessageAlignment: (message is SystemMessage)
          ? AlignmentDirectional.center
          : AlignmentDirectional.centerStart,
      horizontalPadding: (message is SystemMessage) ? 0 : 8,
      child: child,
    );
  }

  Widget? _avatarBuilder({
    required bool shouldShowAvatar,
    required Message message,
    required bool isSystemMessage,
    required ChatType chatType,
  }) {
    Widget? avatar;
    final user = message.metadata?['user'] as ChatUser?;

    if (shouldShowAvatar) {
      final avatarWidget = CustomAvatar(
        id: message.authorId,
        avatarUrl: user?.thumbnail,
        radius: 16,
        name: user?.firstName,
      );

      avatar = Padding(padding: const EdgeInsets.only(right: 8), child: avatarWidget);
    } else if (!isSystemMessage) {
      avatar = const SizedBox(width: 40);
    }

    return avatar;
  }

  Widget? _localChatAvatarBuilder({
    required BuildContext context,
    required bool shouldShowAvatar,
    required Message message,
    required bool isSystemMessage,
    required String languageCode,
  }) {
    Widget? avatar;

    if (shouldShowAvatar) {
      final avatarWidget = CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
        radius: 16,
        child: Text(getFlag(AppLocaleUtils.parseLocaleParts(languageCode: languageCode))),
      );

      avatar = Padding(padding: const EdgeInsets.only(right: 8), child: avatarWidget);
    } else if (!isSystemMessage) {
      avatar = const SizedBox(width: 40);
    }

    return avatar;
  }

  Widget _composerBuilder(BuildContext context) {
    final loc = context.appTexts.chats.chat_page;

    final firstLanguage = state.chat.languages.firstWhere((element) => element.isDefault).languageCode;
    final secondLanguage = state.chat.languages.firstWhere((element) => !element.isDefault).languageCode;

    if (state.chat.type == ChatType.local) {
      return VoiceBarComposerWrapper(
        child: VoiceBar(
          leftLanguageCode: firstLanguage,
          rightLanguageCode: secondLanguage,
          onCompleted: (result) {
            context.read<ChatBloc>().add(
              ChatEvent.voiceCompleted(
                originalLanguageCode: result.lang,
                translatedLanguageCode: result.lang == firstLanguage ? secondLanguage : firstLanguage,
                filePath: result.filePath,
                duration: result.duration,
              ),
            );
          },
        ),
      );
    }

    return Composer(
      hintText: loc.slang_chat_l10n.input_placeholder,
      maxLength: 200,
      sendButtonHidden: true,
      attachmentIcon: null,
    );
  }
}
