import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends ContextBloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc(BuildContext context, this._authRepository)
    : super(switch (_authRepository.status) {
        Authenticated() => const AuthState.loggedIn(),
        LoggedOut() => const AuthState.loggedOut(),
      }, context) {
    on<_AuthStatusChanged>(_onAuthStatusChanged);

    _authRepository.isStatusChanged.listen(_onStatusChanged);
  }

  void _onStatusChanged(AuthStatus status) {
    add(AuthEvent.authStatusChanged(status));
  }

  void _onAuthStatusChanged(_AuthStatusChanged event, Emitter<AuthState> emit) {
    emit(switch (event.status) {
      Authenticated() => const AuthState.loggedIn(),
      LoggedOut() => const AuthState.loggedOut(),
    });
  }
}
