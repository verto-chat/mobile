import 'dart:async';

import 'package:auto_route/auto_route.dart';
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
import '../manager/chat_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.chatId, this.name});

  final String? name;
  final DomainId chatId;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.chats.chat_page;

    return BlocProvider(
      create: (_) => ChatBloc(context, context.read(), context.read(), context.read())..add(ChatEvent.started(chatId)),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: name != null
                  ? Text(name!)
                  : switch (state) {
                      NotInitilized() => null,
                      Initilized() => Text(state.title),
                      Failure() => null,
                    },
            ),
            body: switch (state) {
              NotInitilized() => const Center(child: CircularProgressIndicator()),
              Initilized() => Chat(
                theme: ChatTheme.fromThemeData(Theme.of(context)),
                currentUserId: state.currentUserId,
                chatController: state.chatController,
                resolveUser: (id) async {
                  return null;
                },
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
                  textMessageBuilder:
                      (context, message, index, {required bool isSentByMe, MessageGroupStatus? groupStatus}) =>
                          CustomTextMessage(message: message, index: index),
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
                        return _chatMessageBuilder(
                          context,
                          message,
                          index,
                          animation,
                          child,
                          isRemoved: isRemoved,
                          groupStatus: groupStatus,
                          currentUserId: state.currentUserId,
                          chatType: state.chatType,
                        );
                      },
                  composerBuilder: (context) =>
                      Composer(hintText: loc.slang_chat_l10n.input_placeholder, maxLength: 200),
                  imageMessageBuilder:
                      (context, message, index, {required bool isSentByMe, MessageGroupStatus? groupStatus}) =>
                          FlyerChatImageMessage(message: message, index: index),
                  fileMessageBuilder:
                      (context, message, index, {required bool isSentByMe, MessageGroupStatus? groupStatus}) =>
                          FlyerChatFileMessage(message: message, index: index),
                  emptyChatListBuilder: (context) => Center(child: Text(loc.no_messages_yet)),
                ),
              ),
              Failure() => Center(child: Text(loc.failure)),
            },
          );
        },
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
    required String currentUserId,
    required ChatType chatType,
  }) {
    final isSystemMessage = message.authorId == 'system';
    final isLastInGroup = groupStatus?.isLast ?? true;
    final shouldShowAvatar = !isSystemMessage && isLastInGroup && isRemoved != true;
    final isCurrentUser = message.authorId == currentUserId;

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

  Widget? _avatarBuilder({
    required bool shouldShowAvatar,
    required Message message,
    required bool isSystemMessage,
    required ChatType chatType,
  }) {
    Widget? avatar;
    final user = message.metadata?['user'] as ChatUser?;

    if (shouldShowAvatar) {
      final avatarWidget = chatType == ChatType.support && (user?.isSupport ?? true)
          ? CircleAvatar(backgroundColor: Colors.green.shade400, radius: 16, child: const Icon(Icons.help_outline))
          : CustomAvatar(id: message.authorId, avatarUrl: user?.thumbnail, radius: 16, name: user?.firstName);

      avatar = Padding(padding: const EdgeInsets.only(right: 8), child: avatarWidget);
    } else if (!isSystemMessage) {
      avatar = const SizedBox(width: 40);
    }

    return avatar;
  }
}

//   nameBuilder: (u) => _nameBuilder(context, u),
//   showUserNames: true,
//   emptyState: state.isInitLoading ? const Center(child: CircularProgressIndicator()) : null,
//   isAttachmentUploading: state.isAttachmentUploading,
//   onPreviewDataFetched:
//       (message, previewData) =>
//           context.read<ChatBloc>().add(ChatEvent.loadPreview(message, previewData)),
//   textMessageBuilder: (textMessage, {required messageWidth, required showName}) {
//     return CustomTextMessage(
//       theme: theme,
//       message: textMessage,
//       showName: showName,
//       usePreviewData: true,
//       emojiEnlargementBehavior: EmojiEnlargementBehavior.multi,
//       hideBackgroundOnEmojiMessages: true,
//       nameBuilder: (u) => _nameBuilder(context, u),
//       onPreviewDataFetched:
//           (message, previewData) =>
//               context.read<ChatBloc>().add(ChatEvent.loadPreview(message, previewData)),
//     );
//   },
// );

// Widget _nameBuilder(BuildContext context, User user) => Text(
//   user.firstName ?? "-",
//   style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
// );

// class SlangChatL10n extends ChatL10n {
//   SlangChatL10n(TranslationsChatsChatPageSlangChatL10nRu loc)
//     : super(
//         and: loc.and,
//         attachmentButtonAccessibilityLabel: loc.attachment_button_accessibility_label,
//         emptyChatPlaceholder: loc.empty_chat_placeholder,
//         fileButtonAccessibilityLabel: loc.file_button_accessibility_label,
//         inputPlaceholder: loc.input_placeholder,
//         isTyping: loc.is_typing,
//         others: loc.others,
//         sendButtonAccessibilityLabel: loc.send_button_accessibility_label,
//         unreadMessagesLabel: loc.unread_messages_label,
//       );
// }
