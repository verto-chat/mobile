import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';

String getThemeModeName(ThemeMode themeMode, BuildContext context) {
  final loc = context.appTexts.profile.theme;

  return switch (themeMode) {
    ThemeMode.system => loc.system,
    ThemeMode.light => loc.light,
    ThemeMode.dark => loc.dark,
  };
}

class SelectThemeSheet extends StatelessWidget {
  const SelectThemeSheet({super.key, required this.onThemeModeChanged});

  final void Function(ThemeMode) onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    return SelectSheetContainer(
      children: List.generate(ThemeMode.values.length * 2 - 1, (index) {
        final t = ThemeMode.values[index ~/ 2];

        return index.isEven
            ? CommonSelectTile.fromIcons(
              title: getThemeModeName(t, context),
              onTap: () => onThemeModeChanged(t),
              icon: _getThemeModeIcon(t),
            )
            : const Divider();
      }),
    );
  }

  IconData _getThemeModeIcon(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }
}
