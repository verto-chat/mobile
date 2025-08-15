import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

class LastPageErrorMessageView extends StatelessWidget {
  const LastPageErrorMessageView({super.key, this.onTap});

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(context.appTexts.core.widgets.last_page_error_message_view.something_wrong_try_again),
        const SizedBox(height: 4),
        GestureDetector(onTap: onTap, child: const Icon(Icons.refresh, size: 16)),
      ],
    );
  }
}
