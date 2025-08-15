import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../pages/user_select_screen.dart';

part 'user_select_bloc.freezed.dart';
part 'user_select_event.dart';
part 'user_select_state.dart';

class UserSelectBloc extends ContextBloc<UserSelectEvent, UserSelectState> {
  final IUsersRepository _usersRepository;

  late final SelectUserDelegate _select;

  UserSelectBloc(BuildContext context, this._usersRepository) : super(const UserSelectState.loading(), context) {
    on<_Started>(_onStarted);
    on<_Load>(_onLoad);
    on<_Select>(_onSelect);
  }

  void _onStarted(_Started event, Emitter<UserSelectState> emit) async {
    _select = event.onSelect;

    add(const UserSelectEvent.load());
  }

  Future<void> _onLoad(_Load event, Emitter<UserSelectState> emit) async {
    final result = await _usersRepository.getUsers();

    switch (result) {
      case Success():
        emit(UserSelectState.loaded(users: result.data));
      case Error<List<UserInfo>, DomainErrorType>():
        emit(const UserSelectState.failure());
    }

    event.completer?.complete();
  }

  Future<void> _onSelect(_Select event, Emitter<UserSelectState> emit) async {
    if (state case Loaded loadedState) {
      emit(loadedState.copyWith(isLoading: true));

      final result = await _select(context, event.user);

      emit(loadedState.copyWith(isLoading: false));

      if (result == null) return;

      await showError(result.errorType, customMessage: result.customMessage);
    }
  }
}
