part of 'lang_bloc.dart';

@freezed
sealed class LangState with _$LangState {
  const factory LangState({required AppLocale selectedLocale, @Default(false) bool isLoading}) = _LangState;
}
