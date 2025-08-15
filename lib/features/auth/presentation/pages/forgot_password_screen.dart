import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/translations.g.dart';
import '../managers/forgot_password_bloc.dart';

@RoutePage()
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.auth.reset_password.forgot_password_screen;

    return BlocProvider(
      create: (_) => ForgotPasswordBloc(context, context.read()),
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return SimpleLoader(
            isLoading: state.isLoading,
            child: Scaffold(
              appBar: AppBar(title: Text(loc.title)),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SafeArea(
                      child: SizedBox(height: 80, child: Assets.icons.logo.svg(fit: BoxFit.contain)),
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
                            onChanged: (email) =>
                                context.read<ForgotPasswordBloc>().add(ForgotPasswordEvent.emailChanged(email)),

                            textInputAction: TextInputAction.done,
                          ),

                          const SizedBox(height: 20),

                          FilledButton(
                            onPressed: state.canSend
                                ? () =>
                                      context.read<ForgotPasswordBloc>().add(const ForgotPasswordEvent.sendResetLink())
                                : null,
                            child: Text(loc.send_reset_link),
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
