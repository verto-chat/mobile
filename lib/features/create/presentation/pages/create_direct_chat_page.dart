import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../../users/presentation/pages/user_select_screen.dart';
import '../../domain/create_chats_repository.dart';

@RoutePage()
class CreateDirectChatPage extends UserSelectScreen {
  const CreateDirectChatPage({super.key}) : super(title: _createTitle, onSelect: _handleSelect);

  static Future<SelectUserResult?> _handleSelect(BuildContext context, UserInfo user) async {
    final router = context.router;
    final errorMsg = context.appTexts.chats.create_direct_chat_page.failure_create_chat;

    final result = await context.read<ICreateChatsRepository>().createDirectChat(user);

    switch (result) {
      case Success():
        final chatId = result.data;

        router.maybePop();

        await router.push(ChatRoute(chatId: chatId));

        return null;
      case Error():
        return (errorType: result.errorData, customMessage: errorMsg);
    }
  }

  static String _createTitle(BuildContext context) {
    return context.appTexts.chats.create_direct_chat_page.title;
  }
}
