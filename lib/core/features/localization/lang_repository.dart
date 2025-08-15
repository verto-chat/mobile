import '../../../common/common.dart';
import '../../../i18n/translations.g.dart';

const _localeKey = "LocaleKey";

class LangRepository {
  final ISharedPreferences _sharedPreferences;

  late bool _isCanSetLocale;

  bool get isCanSetLocale => _isCanSetLocale;

  LangRepository(this._sharedPreferences);

  Future<void> init() async {
    final locale = await _sharedPreferences.getString(_localeKey);

    _isCanSetLocale = locale != null;

    if (locale != null) LocaleSettings.setLocale(AppLocaleUtils.parse(locale));
  }

  Future<void> setLocale(AppLocale locale) async {
    _isCanSetLocale = true;

    await LocaleSettings.setLocale(locale);

    await _sharedPreferences.setString(_localeKey, locale.languageTag);
  }

  Future<bool> canSetLocale() async {
    final locale = await _sharedPreferences.getString(_localeKey);
    return locale != null;
  }
}
