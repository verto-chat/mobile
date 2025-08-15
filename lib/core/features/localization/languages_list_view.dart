import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../core.dart';

class LanguagesListView extends StatelessWidget {
  const LanguagesListView({super.key, required this.scrollController, required this.onLanguageChanged});

  final ScrollController scrollController;
  final ValueChanged<AppLocale> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ).copyWith(bottom: 16 + MediaQuery.of(context).padding.bottom),
      itemCount: supportedLocales.length,
      itemBuilder: (context, index) {
        final locale = supportedLocales[index];
        return CommonSelectTile(
          icon: getLocaleIcon(locale),
          title: getLocaleName(locale),
          onTap: () => onLanguageChanged(locale),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
