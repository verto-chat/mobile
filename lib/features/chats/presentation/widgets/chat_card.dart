import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.onTap,
    required this.chat,
    this.isShimmerLoading = false,
    required this.isAdvertChats,
  });

  factory ChatCard.skeleton({Key? key}) {
    return ChatCard(
      onTap: (_, _) {},
      chat: Chat(
        id: const DomainId.fromString(id: "12"),
        name: '',
        avatarUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        type: ChatType.p2p,
        thumbnailAvatarUrl: '',
      ),
      isShimmerLoading: true,
      isAdvertChats: false,
    );
  }

  final void Function(DomainId chatId, String chatName) onTap;
  final Chat chat;
  final bool isShimmerLoading;
  final bool isAdvertChats;

  @override
  Widget build(BuildContext context) {
    if (isShimmerLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CustomShimmer(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                radius: 20,
              ),
            ),
            const SizedBox(width: 16),
            const ShimmerContainer(height: 18, width: 140),
            const Spacer(),
            const ShimmerContainer(height: 12, width: 40),
          ],
        ),
      );
    }

    final chatName = switch (chat.type) {
      ChatType.favorites => context.appTexts.chats.chats_page.chat_card.favorites_chat_name,
      ChatType.support => chat.name ?? context.appTexts.chats.chats_page.chat_card.support_chat_name,
      _ => (chat.name ?? ''),
    };

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(chat.id, chatName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            switch (chat.type) {
              ChatType.favorites => CircleAvatar(
                backgroundColor: Colors.blue.shade400,
                radius: 20,
                child: const Icon(Icons.bookmark_border),
              ),
              ChatType.support => Stack(
                children: [
                  if (chat.name != null) CustomAvatar(id: chat.id, name: chat.name, avatarUrl: chat.thumbnail),

                  CircleAvatar(
                    backgroundColor: Colors.green.shade400,
                    radius: chat.name != null ? 8 : 20,
                    child: Icon(Icons.help_outline, size: chat.name != null ? 12 : 24),
                  ),
                ],
              ),
              _ => CustomAvatar(id: chat.id, name: chat.name, avatarUrl: chat.thumbnail),
            },
            const SizedBox(width: 16),
            Expanded(
              child: Text(chatName, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
            ),
            Text(
              chat.updatedAt != null
                  ? formatChatMessageDate(
                      chat.updatedAt!,
                      locale: TranslationProvider.of(context).flutterLocale.toString(),
                    )
                  : "",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  String formatChatMessageDate(DateTime messageDate, {String? locale}) {
    final now = DateTime.now();

    if (messageDate.year == now.year && messageDate.month == now.month && messageDate.day == now.day) {
      // Выводим только время в формате "HH:mm"
      return DateFormat.Hm(locale).format(messageDate);
    }

    // Если сообщение было в течение последней недели
    if (now.difference(messageDate).inDays < 7) {
      // Выводим сокращённое название дня недели, например "Mon" или в русской локали "Пн"
      return DateFormat.E(locale).format(messageDate);
    }

    // Если сообщение старше недели, выводим месяц и число, например "Feb 11" или "11 фев."
    return DateFormat.MMMd(locale).format(messageDate);
  }
}
