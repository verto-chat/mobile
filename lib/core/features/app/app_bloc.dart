import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/common.dart';
import '../../core.dart';

part 'app_bloc.freezed.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  static const _themeModeKey = "ThemeModeKey";

  final ISharedPreferences _prefs;
  final TokenService _tokenService;

  AppBloc(BuildContext context, this._prefs, this._tokenService) : super(const AppState(themeMode: ThemeMode.system)) {
    on<_Started>(_onStarted);
    on<_ChangeThemeMode>(_onChangeThemeMode);

    add(const AppEvent.started());
  }

  Future<void> _onStarted(_Started event, Emitter<AppState> emit) async {
    final themeMode =
        ThemeMode.values.firstWhereOrNull((e) => e.name == _prefs.getString(_themeModeKey)) ?? ThemeMode.system;

    emit(state.copyWith(themeMode: themeMode));

    await _tokenService.start();
  }

  Future<void> _onChangeThemeMode(_ChangeThemeMode event, Emitter<AppState> emit) async {
    await _prefs.setString(_themeModeKey, event.themeMode.name);

    emit(state.copyWith(themeMode: event.themeMode));
  }
}
