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
    required this.onLongTap,
    this.isShimmerLoading = false,
  });

  factory ChatCard.skeleton({Key? key}) {
    return ChatCard(onTap: () {}, onLongTap: () {}, chat: emptyChat, isShimmerLoading: true);
  }

  final void Function() onTap;
  final void Function() onLongTap;
  final Chat chat;
  final bool isShimmerLoading;

  @override
  Widget build(BuildContext context) {
    if (isShimmerLoading) {
      return const _Skeleton();
    }

    final firstLanguageCode = chat.languages?.firstWhere((element) => element.isDefault).languageCode;
    final secondLanguageCode = chat.languages?.firstWhere((element) => !element.isDefault).languageCode;

    final firstFlag = firstLanguageCode != null
        ? getFlag(AppLocaleUtils.parseLocaleParts(languageCode: firstLanguageCode))
        : '';
    final secondFlag = secondLanguageCode != null
        ? getFlag(AppLocaleUtils.parseLocaleParts(languageCode: secondLanguageCode))
        : '';

    final chatName = switch (chat.type) {
      ChatType.local => chat.name ?? "Local - $firstFlag - $secondFlag",
      _ => (chat.name ?? ''),
    };

    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            switch (chat.type) {
              ChatType.local => CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                radius: 20,
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(firstFlag, style: const TextStyle(fontSize: 12)),
                    Text(secondFlag, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              _ => CustomAvatar(id: chat.id, name: chat.name, avatarUrl: chat.thumbnail),
            },
            const SizedBox(width: 16),
            Expanded(
              child: Text(chatName, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
            ),
            Text(
              formatChatMessageDate(chat.updatedAt, locale: TranslationProvider.of(context).flutterLocale.toString()),
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

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
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
}
