import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';

enum ChatAttachmentType { image, file }

class SelectAttachmentTypeSheet extends StatelessWidget {
  const SelectAttachmentTypeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectSheetContainer(
      children: [
        CommonSelectTile.fromIcons(
          onTap: () => Navigator.pop(context, ChatAttachmentType.image),
          icon: Icons.image,
          title: context.appTexts.chats.chat_page.attachment_type_image,
        ),
        const Divider(),
        CommonSelectTile.fromIcons(
          onTap: () => Navigator.pop(context, ChatAttachmentType.file),
          icon: Icons.attach_file,
          title: context.appTexts.chats.chat_page.attachment_type_file,
        ),
      ],
    );
  }
}
