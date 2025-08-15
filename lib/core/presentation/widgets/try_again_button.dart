import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({super.key, required this.tryAgainAction, this.customMessage});

  final VoidCallback tryAgainAction;
  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            customMessage ?? context.appTexts.core.widgets.try_again_button.something_wrong,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: tryAgainAction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(context.appTexts.core.widgets.try_again_button.try_again),
          ),
        ),
      ],
    );
  }
}
