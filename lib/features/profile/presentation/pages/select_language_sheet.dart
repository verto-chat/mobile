import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';

class SelectLanguageSheet extends StatelessWidget {
  const SelectLanguageSheet({super.key, required this.onLanguageChanged});

  final void Function(AppLocale) onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: 0.9,
      expand: true,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Expanded(
                child: LanguagesListView(
                  scrollController: scrollController,
                  onLanguageChanged: (locale) => onLanguageChanged(locale),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
