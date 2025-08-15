import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../router/app_router.dart';
import '../../auth.dart';

part 'forgot_password_bloc.freezed.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends ContextBloc<ForgotPasswordEvent, ForgotPasswordState> {
  final IAuthRepository _authRepository;

  ForgotPasswordBloc(BuildContext context, this._authRepository) : super(const ForgotPasswordState(), context) {
    on<_SendResetLink>(_onSendResetLink);
    on<_EmailChanged>(_onEmailChanged);
  }

  Future<void> _onSendResetLink(_SendResetLink event, Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(isLoading: true));

    final email = state.email.value;

    final result = await _authRepository.sendResetPasswordCode(email: email);

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        router?.replace(CodeRoute(email: email));
      case Error():
        showError(
          result.errorData,
          customMessage: appTexts.auth.reset_password.forgot_password_screen.check_error_description,
        );
    }
  }

  Future<void> _onEmailChanged(_EmailChanged event, Emitter<ForgotPasswordState> emit) async {
    final email = Email.dirty(event.email);

    emit(state.copyWith(email: email, canSend: Formz.validate([email])));
  }
}
