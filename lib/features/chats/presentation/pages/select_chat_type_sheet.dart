import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';

class SelectChatTypeSheet extends StatelessWidget {
  const SelectChatTypeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectSheetContainer(
      children: [
        CommonSelectTile.fromIcons(
          onTap: () => Navigator.pop(context, ChatType.direct),
          icon: Icons.person,
          title: context.appTexts.chats.chats_page.create_direct_chat,
        ),
        const Divider(),
        CommonSelectTile.fromIcons(
          onTap: () => Navigator.pop(context, ChatType.group),
          icon: Icons.group,
          title: context.appTexts.chats.chats_page.create_group_chat,
        ),
      ],
    );
  }
}
