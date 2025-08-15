import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import 'base_chats_page.dart';

@RoutePage()
class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseChatsPage(name: context.appTexts.chats.chats_page.title);
  }
}
