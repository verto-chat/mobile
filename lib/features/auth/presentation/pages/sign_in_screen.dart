import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/translations.g.dart';
import '../../auth.dart';
import '../managers/sign_in_bloc.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.auth.sign_in_screen;

    return BlocProvider(
      create: (_) => createSignInBloc(context),
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          return SimpleLoader(
            isLoading: state.isLoading,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SafeArea(
                      child: SizedBox(height: 100, child: Assets.icons.logo.svg(fit: BoxFit.contain)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0).copyWith(top: 0),
                      child: Column(
                        spacing: 24,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: loc.email_label,
                              errorText: switch (state.email.displayError) {
                                null => null,
                                EmailValidationError.empty => context.appTexts.core.field_empty,
                                EmailValidationError.incorrect => context.appTexts.core.incorrect_format,
                              },
                            ),
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (email) => context.read<SignInBloc>().add(SignInEvent.emailChanged(email)),
                            textInputAction: TextInputAction.next,
                          ),
                          PasswordField(
                            label: loc.password_label,
                            onChanged: (password) =>
                                context.read<SignInBloc>().add(SignInEvent.passwordChanged(password)),
                            errorText: state.password.displayError != null ? context.appTexts.core.field_empty : null,
                            textInputAction: TextInputAction.done,
                          ),
                          TextButton(
                            onPressed: () => context.read<SignInBloc>().add(const SignInEvent.forgotPassword()),
                            child: Text(loc.forgot_password),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: state.canSignIn
                                ? () => context.read<SignInBloc>().add(const SignInEvent.signIn())
                                : null,
                            child: Text(loc.sign_in),
                          ),
                          Center(
                            child: ElevatedButton.icon(
                              icon: Assets.icons.google.svg(width: 24, height: 24),
                              onPressed: () => context.read<SignInBloc>().add(const SignInEvent.signInWithGoogle()),
                              label: Text(loc.sign_in_with_google),
                            ),
                          ),

                          if (Platform.isIOS)
                            Center(
                              child: ElevatedButton.icon(
                                icon: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CustomPaint(
                                    painter: AppleLogoPainter(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                                onPressed: () => context.read<SignInBloc>().add(const SignInEvent.signInWithApple()),
                                label: Text(loc.sign_in_with_apple),
                              ),
                            ),

                          TextButton(
                            onPressed: () => context.read<SignInBloc>().add(const SignInEvent.signUp()),
                            child: Text(loc.sign_up),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
