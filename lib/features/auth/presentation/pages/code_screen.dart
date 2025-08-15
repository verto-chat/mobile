import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/entities/reset_code_status.dart';
import '../managers/code_bloc.dart';

@RoutePage()
class CodeScreen extends StatelessWidget {
  final String email;

  const CodeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CodeBloc(context, email, context.read()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.appTexts.auth.reset_password.code_screen.title)),
        body: const _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.auth.reset_password.code_screen;

    return BlocBuilder<CodeBloc, CodeState>(
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
                      Text(loc.description(email: state.email)),
                      const SizedBox(height: 32),
                      InputField(
                        label: loc.field_label,
                        textInputType: TextInputType.emailAddress,
                        onChanged: (code) => context.read<CodeBloc>().add(CodeEvent.codeChanged(code)),
                        textInputAction: TextInputAction.next,
                        errorText: state.codeStatus == ResetCodeStatus.incorrect ? loc.field_error : null,
                      ),
                      const SizedBox(height: 40),
                      FilledButton(
                        onPressed: state.code.isNotEmpty
                            ? () => context.read<CodeBloc>().add(const CodeEvent.submit())
                            : null,
                        child: Text(loc.submit),
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
}
