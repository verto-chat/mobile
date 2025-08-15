part of 'app_bloc.dart';

@freezed
sealed class AppState with _$AppState {
  const factory AppState({required ThemeMode themeMode}) = _AppState;
}
