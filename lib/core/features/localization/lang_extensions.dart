import 'package:flutter/cupertino.dart';

import '../../../i18n/translations.g.dart';

String get languageCode => LocaleSettings.currentLocale.languageTag;

String get languageCodeNew => LocaleSettings.currentLocale.languageCode;

const List<AppLocale> supportedLocales = AppLocale.values;

String getLocaleName(AppLocale locale) => switch (locale) {
  AppLocale.ru => "Русский",
  AppLocale.en => "English",
  AppLocale.sr => "Srpski",
  AppLocale.bg => "Български",
  AppLocale.de => "Deutsch",
  AppLocale.hu => "Magyar",
  AppLocale.ro => "Română",
  AppLocale.uk => "Українська",
  AppLocale.ar => "العربية",
  AppLocale.be => "Беларуская",
  AppLocale.ca => "Català",
  AppLocale.cs => "Čeština",
  AppLocale.es => "Español",
  AppLocale.fa => "فارسی",
  AppLocale.fi => "Suomi",
  AppLocale.fr => "Français",
  AppLocale.he => "עברית",
  AppLocale.hr => "Hrvatski",
  AppLocale.id => "Bahasa Indonesia",
  AppLocale.it => "Italiano",
  AppLocale.kk => "Қазақша",
  AppLocale.ko => "한국어",
  AppLocale.ms => "Bahasa Melayu",
  AppLocale.nb => "Norsk (Bokmål)",
  AppLocale.nl => "Nederlands",
  AppLocale.pl => "Polski",
  AppLocale.pt => "Português",
  AppLocale.sk => "Slovenčina",
  AppLocale.sv => "Svenska",
  AppLocale.tr => "Türkçe",
  AppLocale.uz => "Oʻzbek",
  AppLocale.vi => "Tiếng Việt",
  AppLocale.zh => "中文",
};

Widget getLocaleIcon(AppLocale locale, {double? fontSize}) {
  final style = fontSize != null ? TextStyle(fontSize: fontSize) : null;

  return Text(getFlag(locale), style: style);
}

String getFlag(AppLocale locale) {
  return switch (locale) {
    AppLocale.ru => "🇷🇺",
    AppLocale.en => "🇬🇧",
    AppLocale.sr => "🇷🇸",
    AppLocale.bg => "🇧🇬",
    AppLocale.de => "🇩🇪",
    AppLocale.hu => "🇭🇺",
    AppLocale.ro => "🇷🇴",
    AppLocale.uk => "🇺🇦",
    AppLocale.ar => "🇸🇦",
    AppLocale.be => "🇧🇾",
    AppLocale.ca => "🇦🇩",
    AppLocale.cs => "🇨🇿",
    AppLocale.es => "🇪🇸",
    AppLocale.fa => "🇮🇷",
    AppLocale.fi => "🇫🇮",
    AppLocale.fr => "🇫🇷",
    AppLocale.he => "🇮🇱",
    AppLocale.hr => "🇭🇷",
    AppLocale.id => "🇮🇩",
    AppLocale.it => "🇮🇹",
    AppLocale.kk => "🇰🇿",
    AppLocale.ko => "🇰🇷",
    AppLocale.ms => "🇲🇾",
    AppLocale.nb => "🇳🇴",
    AppLocale.nl => "🇳🇱",
    AppLocale.pl => "🇵🇱",
    AppLocale.pt => "🇵🇹",
    AppLocale.sk => "🇸🇰",
    AppLocale.sv => "🇸🇪",
    AppLocale.tr => "🇹🇷",
    AppLocale.uz => "🇺🇿",
    AppLocale.vi => "🇻🇳",
    AppLocale.zh => "🇨🇳",
  };
}
