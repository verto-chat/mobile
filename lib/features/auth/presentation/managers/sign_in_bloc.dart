import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../router/app_router.dart';
import '../../data/repositories/apple_sign_in_provider.dart';
import '../../data/repositories/google_sign_in_provider.dart';
import '../../domain/domain.dart';
import '../pages/oauth_accept_regulations_sheet.dart';
import '../utils/login_err_to_dialog.dart';

part 'sign_in_bloc.freezed.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends ContextBloc<SignInEvent, SignInState> {
  final IAuthRepository _authRepository;
  final GoogleSignInProvider _googleSignInProvider;
  final AppleSignInProvider _appleSignInProvider;

  SignInBloc(BuildContext context, this._authRepository, this._googleSignInProvider, this._appleSignInProvider)
    : super(const SignInState(), context) {
    on<_PasswordChanged>(_onPasswordChanged);
    on<_ForgotPassword>(_onForgotPassword);
    on<_EmailChanged>(_onEmailChanged);

    on<_SignIn>(_onSignIn);
    on<_SignInWithGoogle>(_onSignInWithGoogle);
    on<_SignInWithApple>(_onSignInWithApple);
    on<_SignUp>(_onSignUp);
  }

  void _onPasswordChanged(_PasswordChanged event, Emitter<SignInState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(password: password, canSignIn: Formz.validate([state.email, password])));
  }

  void _onEmailChanged(_EmailChanged event, Emitter<SignInState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(email: email, canSignIn: Formz.validate([email, state.password])));
  }

  Future<void> _onSignIn(_SignIn event, Emitter<SignInState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.loginByEmail(email: state.email.value, password: state.password.value);

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        break;
      case Error():
        if (!context.mounted) return;
        await showMessage(result.errorData.toDialog(context));
    }
  }

  Future<void> _onSignInWithGoogle(_SignInWithGoogle event, Emitter<SignInState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.loginByGoogle();

    emit(state.copyWith(isLoading: false));

    if (!context.mounted) return;

    switch (result) {
      case Success():
        switch (result.data) {
          case GoogleLoginRegistered():
            break;
          case GoogleLoginNotRegistered(:final googleUser):
            final acceptRegulations = await showModalBottomSheet<bool>(
              context: context,
              builder: (context) => const OAuthAcceptRegulationsSheet(),
            );

            if (acceptRegulations ?? false) {
              final authResult = await _googleSignInProvider.signIn(googleUser);

              switch (authResult) {
                case Success():
                  final regResult = await _authRepository.completeRegistration(authResult.data);

                  switch (regResult) {
                    case Success():
                      break;
                    case Error():
                      showError(regResult.errorData);
                  }
                case Error():
                  showError(authResult.errorData);
              }
            }
        }

      case Error():
        showError(result.errorData);
    }
  }

  Future<void> _onSignInWithApple(_SignInWithApple event, Emitter<SignInState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.loginByApple();

    emit(state.copyWith(isLoading: false));

    if (!context.mounted) return;

    switch (result) {
      case Success():
        switch (result.data) {
          case AppleLoginRegistered():
            break;
          case AppleLoginNotRegistered(:final authResult):
            final acceptRegulations = await showModalBottomSheet<bool>(
              context: context,
              builder: (context) => const OAuthAcceptRegulationsSheet(),
            );

            if (acceptRegulations ?? false) {
              final signInResult = await _appleSignInProvider.signIn(authResult.user.identityToken!, authResult.nonce);

              switch (signInResult) {
                case Success():
                  final regResult = await _authRepository.completeRegistration(signInResult.data);

                  switch (regResult) {
                    case Success():
                      break;
                    case Error():
                      showError(regResult.errorData);
                  }
                case Error():
                  showError(signInResult.errorData);
              }
            }
        }

      case Error():
        showError(result.errorData);
    }
  }

  Future<void> _onSignUp(_SignUp event, Emitter<SignInState> emit) async {
    await router?.push(const SignUpRoute());
  }

  Future<void> _onForgotPassword(_ForgotPassword event, Emitter<SignInState> emit) async {
    await router?.push(const ForgotPasswordRoute());
  }
}
