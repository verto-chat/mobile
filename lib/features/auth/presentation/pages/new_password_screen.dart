import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/translations.g.dart';
import '../managers/new_password_bloc.dart';

enum NewPasswordNavigationPurpose { reset, edit }

@RoutePage()
class NewPasswordScreen extends StatelessWidget {
  final NewPasswordNavigationPurpose navigationPurpose;

  const NewPasswordScreen({super.key, required this.navigationPurpose});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPasswordBloc(context, navigationPurpose, context.read()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.appTexts.auth.reset_password.new_password_screen.title)),
        body: _Content(navigationPurpose),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final NewPasswordNavigationPurpose _navigationPurpose;

  const _Content(this._navigationPurpose);

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.auth.reset_password.new_password_screen;

    return BlocBuilder<NewPasswordBloc, NewPasswordState>(
      builder: (context, state) {
        return SimpleLoader(
          isLoading: state.isLoading,
          child: SingleChildScrollView(
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
                      if (_navigationPurpose == NewPasswordNavigationPurpose.edit)
                        PasswordField(
                          onChanged: (value) =>
                              context.read<NewPasswordBloc>().add(NewPasswordEvent.currentPasswordChanged(value)),
                          errorText: state.currentPassword.displayError != null
                              ? context.appTexts.core.field_empty
                              : null,
                          label: loc.current_password,
                          textInputAction: TextInputAction.next,
                        ),
                      PasswordField(
                        onChanged: (value) =>
                            context.read<NewPasswordBloc>().add(NewPasswordEvent.passwordChanged(value)),
                        errorText: state.password.displayError != null ? context.appTexts.core.field_empty : null,
                        label: _navigationPurpose == NewPasswordNavigationPurpose.edit
                            ? loc.new_password
                            : loc.password_label,
                        textInputAction: TextInputAction.next,
                      ),
                      PasswordField(
                        onChanged: (value) =>
                            context.read<NewPasswordBloc>().add(NewPasswordEvent.confirmPasswordChanged(value)),
                        errorText: state.confirmedPassword.displayError != null
                            ? _getErrorText(state.confirmedPassword.displayError!, context)
                            : null,
                        label: _navigationPurpose == NewPasswordNavigationPurpose.edit
                            ? loc.repeat_new_password
                            : loc.repeat_password,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 40),
                      FilledButton(
                        onPressed: state.isValid
                            ? () => context.read<NewPasswordBloc>().add(const NewPasswordEvent.submit())
                            : null,
                        child: Text(switch (_navigationPurpose) {
                          NewPasswordNavigationPurpose.reset => loc.reset_submit,
                          NewPasswordNavigationPurpose.edit => loc.edit_submit,
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getErrorText(ConfirmedPasswordValidationError error, BuildContext context) {
    return switch (error) {
      ConfirmedPasswordValidationError.empty => context.appTexts.core.field_empty,
      ConfirmedPasswordValidationError.notEqual => context.appTexts.auth.sign_up_screen.password_not_equal,
    };
  }
}
