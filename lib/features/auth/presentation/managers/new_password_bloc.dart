import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../pages/new_password_screen.dart';

part 'new_password_bloc.freezed.dart';
part 'new_password_event.dart';
part 'new_password_state.dart';

class NewPasswordBloc extends ContextBloc<NewPasswordEvent, NewPasswordState> {
  final IAuthRepository _authRepository;
  final NewPasswordNavigationPurpose _navigationPurpose;

  NewPasswordBloc(BuildContext context, this._navigationPurpose, this._authRepository)
    : super(NewPasswordState(navigationPurpose: _navigationPurpose), context) {
    on<_CurrentPasswordChanged>(_onCurrentPasswordChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<_Submit>(_onSubmit);
  }

  void _onCurrentPasswordChanged(_CurrentPasswordChanged event, Emitter<NewPasswordState> emit) {
    final currentPassword = Password.dirty(event.value);

    emit(
      state.copyWith(
        currentPassword: currentPassword,
        isValid: Formz.validate([currentPassword, state.password, state.confirmedPassword]),
      ),
    );
  }

  void _onPasswordChanged(_PasswordChanged event, Emitter<NewPasswordState> emit) {
    final password = Password.dirty(event.value);

    if (state.confirmedPassword.isPure) {
      final isValid = _navigationPurpose == NewPasswordNavigationPurpose.edit
          ? Formz.validate([state.currentPassword, password, state.confirmedPassword])
          : Formz.validate([password, state.confirmedPassword]);

      emit(state.copyWith(password: password, isValid: isValid));
      return;
    }

    final confirmedPassword = ConfirmedPassword.dirty(original: password, value: state.confirmedPassword.value);

    final isValid = _navigationPurpose == NewPasswordNavigationPurpose.edit
        ? Formz.validate([state.currentPassword, password, confirmedPassword])
        : Formz.validate([password, confirmedPassword]);

    emit(state.copyWith(password: password, confirmedPassword: confirmedPassword, isValid: isValid));
  }

  void _onConfirmPasswordChanged(_ConfirmPasswordChanged event, Emitter<NewPasswordState> emit) {
    final confirmedPassword = ConfirmedPassword.dirty(original: state.password, value: event.value);

    final isValid = _navigationPurpose == NewPasswordNavigationPurpose.edit
        ? Formz.validate([state.currentPassword, confirmedPassword, state.password])
        : Formz.validate([confirmedPassword, state.password]);

    emit(state.copyWith(confirmedPassword: confirmedPassword, isValid: isValid));
  }

  Future<void> _onSubmit(_Submit event, Emitter<NewPasswordState> emit) async {
    switch (_navigationPurpose) {
      case NewPasswordNavigationPurpose.reset:
        await _reset(event, emit);
        return;
      case NewPasswordNavigationPurpose.edit:
        await _change(event, emit);
        return;
    }
  }

  Future<void> _change(_Submit event, Emitter<NewPasswordState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.changePassword(
      currentPassword: state.currentPassword.value,
      password: state.password.value,
    );

    emit(state.copyWith(isLoading: false));

    if (!context.mounted) return;

    switch (result) {
      case Success():
        router?.maybePop();

      case Error():
        switch (result.errorData) {
          case ChangePasswordDefaultError(:final domainErrorType):
            showError(
              domainErrorType,
              customMessage: appTexts.auth.reset_password.new_password_screen.failed_reset_password,
            );
          case ChangePasswordError(:final type):
            final loc = appTexts.auth.reset_password.new_password_screen.errors;

            await DialogCorePresenter.showMessage(
              context,
              DialogInfo(
                title: appTexts.core.dialog_title.error_title,
                description: switch (type) {
                  ChangePasswordStatus.incorrect => appTexts.auth.sign_up_screen.register_error.incorrect_password,
                  ChangePasswordStatus.wrongCurrentPassword => loc.wrong_current_password,
                  ChangePasswordStatus.samePassword => loc.same_password,
                },
                actions: [
                  DialogActionInfo(
                    actionType: ErrorActionType.ok,
                    actionName: appTexts.core.dialog_action.ok,
                    actionStyle: DialogActionStyle.primary,
                  ),
                ],
              ),
            );
        }
    }
  }

  Future<void> _reset(_Submit event, Emitter<NewPasswordState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.resetPassword(password: state.password.value);

    emit(state.copyWith(isLoading: false));

    if (!context.mounted) return;

    switch (result) {
      case Success():
        router?.maybePop();
      case Error():
        switch (result.errorData) {
          case ResetPasswordDefaultError(:final domainErrorType):
            showError(
              domainErrorType,
              customMessage: appTexts.auth.reset_password.new_password_screen.failed_reset_password,
            );
          case ResetPasswordError(:final type):
            final loc = appTexts.auth.reset_password.new_password_screen.errors;

            await DialogCorePresenter.showMessage(
              context,
              DialogInfo(
                title: appTexts.core.dialog_title.error_title,
                description: switch (type) {
                  ResetPasswordStatus.incorrect => appTexts.auth.sign_up_screen.register_error.incorrect_password,
                  ResetPasswordStatus.samePassword => loc.same_password,
                },
                actions: [
                  DialogActionInfo(
                    actionType: ErrorActionType.ok,
                    actionName: appTexts.core.dialog_action.ok,
                    actionStyle: DialogActionStyle.primary,
                  ),
                ],
              ),
            );
        }
    }
  }
}
