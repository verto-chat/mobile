import 'package:auto_route/auto_route.dart';
import 'package:context_di/context_di.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../legal/legal.dart';
import '../../auth.dart';
import '../managers/sign_up_bloc.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.auth.sign_up_screen;

    final textTheme = Theme.of(context).textTheme;
    final legalTextStyle = textTheme.bodyLarge!;
    final accentedLegalTextStyle = legalTextStyle.copyWith(color: Theme.of(context).colorScheme.primary);

    return LegalFeature(
      builder: (context, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => createSignUpBloc(context)),
            BlocProvider(create: (_) => context.resolve<CreateLegalBloc>().call(context)),
          ],
          child: Scaffold(
            body: BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                return BlocBuilder<LegalBloc, LegalState>(
                  builder: (context, legalState) {
                    return SimpleLoader(
                      isLoading: legalState.isLoaded || state.isLoading,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(title: Text(loc.title)),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            sliver: SliverList.list(
                              children: [
                                const SizedBox(height: 20),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: '${loc.first_name_label}*',
                                    errorText: state.firstName.displayError != null
                                        ? context.appTexts.core.field_empty
                                        : null,
                                  ),
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (firstName) =>
                                      context.read<SignUpBloc>().add(SignUpEvent.firstNameChanged(firstName)),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: loc.last_name_label,
                                    errorText: state.firstName.displayError != null
                                        ? context.appTexts.core.field_empty
                                        : null,
                                  ),
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (lastName) =>
                                      context.read<SignUpBloc>().add(SignUpEvent.lastNameChanged(lastName)),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: '${loc.email_label}*',
                                    errorText: switch (state.email.displayError) {
                                      null => null,
                                      EmailValidationError.empty => context.appTexts.core.field_empty,
                                      EmailValidationError.incorrect => context.appTexts.core.incorrect_format,
                                    },
                                  ),
                                  textCapitalization: TextCapitalization.none,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (email) => context.read<SignUpBloc>().add(SignUpEvent.emailChanged(email)),
                                ),
                                const SizedBox(height: 40),
                                PasswordField(
                                  label: loc.password_label,
                                  onChanged: (password) =>
                                      context.read<SignUpBloc>().add(SignUpEvent.passwordChanged(password)),
                                  errorText: state.password.displayError != null
                                      ? context.appTexts.core.field_empty
                                      : null,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 20),
                                PasswordField(
                                  label: '${loc.repeat_password}*',
                                  onChanged: (repeatPassword) => context.read<SignUpBloc>().add(
                                    SignUpEvent.confirmPasswordChanged(repeatPassword),
                                  ),
                                  errorText: state.confirmedPassword.displayError != null
                                      ? _getErrorText(context, state.confirmedPassword.displayError!)
                                      : null,
                                  textInputAction: TextInputAction.done,
                                ),
                                const SizedBox(height: 40),

                                Row(
                                  children: [
                                    Checkbox(
                                      value: state.isLegalAccepted,
                                      onChanged: (value) => context.read<SignUpBloc>().add(
                                        SignUpEvent.legalAcceptedChanged(value ?? false),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text.rich(
                                        style: legalTextStyle,
                                        loc.regulations(
                                          terms: (text) => TextSpan(
                                            text: text,
                                            style: accentedLegalTextStyle,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                context.read<LegalBloc>().add(const LegalEvent.openTerms());
                                              },
                                          ),
                                          policy: (text) => TextSpan(
                                            text: text,
                                            style: accentedLegalTextStyle,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                context.read<LegalBloc>().add(const LegalEvent.openPolicy());
                                              },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                FilledButton(
                                  onPressed: state.isValid && state.isLegalAccepted
                                      ? () => context.read<SignUpBloc>().add(const SignUpEvent.register())
                                      : null,
                                  child: Text(loc.sign_up),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(height: MediaQuery.paddingOf(context).bottom),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _getErrorText(BuildContext context, ConfirmedPasswordValidationError error) {
    return switch (error) {
      ConfirmedPasswordValidationError.empty => context.appTexts.core.field_empty,
      ConfirmedPasswordValidationError.notEqual => context.appTexts.auth.sign_up_screen.password_not_equal,
    };
  }
}
