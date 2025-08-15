part of 'lang_bloc.dart';

@freezed
sealed class LangEvent with _$LangEvent {
  const factory LangEvent.changeLanguage({required AppLocale locale, Completer<void>? completer}) = _ChangeLanguage;
}
