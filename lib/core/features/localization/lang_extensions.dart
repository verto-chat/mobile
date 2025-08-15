import 'package:flutter/cupertino.dart';

import '../../../i18n/translations.g.dart';

String get languageCode => LocaleSettings.currentLocale.languageTag;

String get languageCodeNew => LocaleSettings.currentLocale.languageCode;

const List<AppLocale> supportedLocales = AppLocale.values;

String getLocaleName(AppLocale locale) => switch (locale) {
  AppLocale.ru => "Русский",
  AppLocale.en => "English",
  AppLocale.srLatnRs => "Srpski",
  AppLocale.ro => "Română",
  AppLocale.uk => "Українська",
  AppLocale.bg => "Български",
  AppLocale.de => "Deutsch",
  AppLocale.hu => "Magyar",
};

Widget getLocaleIcon(AppLocale locale) => switch (locale) {
  AppLocale.ru => const Text("🇷🇺"),
  AppLocale.en => const Text("🇬🇧"),
  AppLocale.srLatnRs => const Text("🇷🇸"),
  AppLocale.bg => const Text("🇧🇬"),
  AppLocale.de => const Text("🇩🇪"),
  AppLocale.hu => const Text("🇭🇺"),
  AppLocale.ro => const Text("🇷🇴"),
  AppLocale.uk => const Text("🇺🇦"),
};
