import 'package:context_di/context_di.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../i18n/translations.g.dart';
import '../../../legal/legal.dart';

class OAuthAcceptRegulationsSheet extends StatelessWidget {
  const OAuthAcceptRegulationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentedTextStyle = textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary);

    final loc = context.appTexts.auth.sign_in_screen.o_auth_accept_regulations_sheet;

    return LegalFeature(
      builder: (context, _) {
        return BlocProvider(
          create: (_) => context.resolve<CreateLegalBloc>().call(context),
          child: BlocBuilder<LegalBloc, LegalState>(
            builder: (context, state) {
              return SimpleLoader(
                isLoading: state.isLoaded,
                child: SafeArea(
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(loc.title, style: textTheme.titleLarge),
                            Text.rich(
                              style: textTheme.bodyLarge,
                              loc.regulations(
                                terms:
                                    (text) => TextSpan(
                                      text: text,
                                      style: accentedTextStyle,
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              context.read<LegalBloc>().add(const LegalEvent.openTerms());
                                            },
                                    ),
                                policy:
                                    (text) => TextSpan(
                                      text: text,
                                      style: accentedTextStyle,
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              context.read<LegalBloc>().add(const LegalEvent.openPolicy());
                                            },
                                    ),
                              ),
                            ),
                            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(loc.accept)),
                            FilledButton.tonal(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(loc.cancel),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
