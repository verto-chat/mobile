import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../utils/register_err_to_dialog.dart';

part 'sign_up_bloc.freezed.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends ContextBloc<SignUpEvent, SignUpState> {
  final IAuthRepository _authService;

  SignUpBloc(this._authService, BuildContext context) : super(const SignUpState(), context) {
    on<_FirstNameChanged>(_onFirstNameChanged);
    on<_LastNameChanged>(_onLastNameChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<_EmailChanged>(_onEmailChanged);
    on<_LegalAcceptedChanged>(_onLegalAcceptedChanged);

    on<_Register>(_onRegister);
  }

  Future<void> _onFirstNameChanged(_FirstNameChanged event, Emitter<SignUpState> emit) async {
    final name = Username.dirty(event.name);

    emit(
      state.copyWith(
        firstName: name,
        isValid: Formz.validate([name, state.email, state.password, state.confirmedPassword]),
      ),
    );
  }

  Future<void> _onLastNameChanged(_LastNameChanged event, Emitter<SignUpState> emit) async {
    final name = Username.dirty(event.name);

    emit(state.copyWith(lastName: name));
  }

  Future<void> _onPasswordChanged(_PasswordChanged event, Emitter<SignUpState> emit) async {
    final password = Password.dirty(event.password);
    final confirmPassword = ConfirmedPassword.dirty(original: password, value: state.confirmedPassword.value);

    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmPassword,
        isValid: Formz.validate([password, confirmPassword, state.firstName, state.email]),
      ),
    );
  }

  Future<void> _onConfirmPasswordChanged(_ConfirmPasswordChanged event, Emitter<SignUpState> emit) async {
    final confirmPassword = ConfirmedPassword.dirty(original: state.password, value: event.confirmPassword);

    emit(
      state.copyWith(
        confirmedPassword: confirmPassword,
        isValid: Formz.validate([confirmPassword, state.firstName, state.email, state.password]),
      ),
    );
  }

  Future<void> _onEmailChanged(_EmailChanged event, Emitter<SignUpState> emit) async {
    final email = Email.dirty(event.email);

    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.firstName, state.confirmedPassword, state.password]),
      ),
    );
  }

  void _onLegalAcceptedChanged(_LegalAcceptedChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(isLegalAccepted: event.isAccepted));
  }

  Future<void> _onRegister(_Register event, Emitter<SignUpState> emit) async {
    if (!state.isValid || !state.isLegalAccepted) return;

    emit(state.copyWith(isLoading: true));

    final result = await _authService.register(
      firstName: _removeLongSpaces(state.firstName.value),
      lastName: state.lastName.value,
      email: state.email.value,
      password: state.password.value,
    );

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        showToast(message: appTexts.auth.sign_up_screen.after_registration_toast, duration: const Duration(seconds: 3));
        router?.maybePop();
      case Error():
        if (!context.mounted) return;

        await showMessage(result.errorData.toDialog(context));
    }
  }

  String _removeLongSpaces(String input) {
    const pattern = r'\s{2,}';
    final regExp = RegExp(pattern);

    return input.replaceAll(regExp, ' ').trim();
  }
}
