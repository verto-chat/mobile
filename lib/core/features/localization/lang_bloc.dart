import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/common.dart';
import '../../../i18n/translations.g.dart';
import 'lang_repository.dart';

part 'lang_bloc.freezed.dart';
part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends ContextBloc<LangEvent, LangState> {
  final LangRepository _langRepository;

  LangBloc(BuildContext context, this._langRepository)
    : super(LangState(selectedLocale: LocaleSettings.currentLocale), context) {
    on<_ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onChangeLanguage(_ChangeLanguage event, Emitter<LangState> emit) async {
    emit(state.copyWith(isLoading: true));

    await _langRepository.setLocale(event.locale);

    emit(state.copyWith(selectedLocale: event.locale, isLoading: false));

    event.completer?.complete();
  }
}
