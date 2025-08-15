import 'package:auto_route/auto_route.dart';
import 'package:context_di/context_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../i18n/translations.g.dart';
import '../../../profile/presentation/widgets/widgets.dart';
import '../../legal.dart';

@RoutePage()
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.legal.legal_screen;

    return LegalFeature(
      builder: (context, _) {
        return BlocProvider(
          create: (_) => context.resolve<CreateLegalBloc>().call(context),
          child: Scaffold(
            body: BlocBuilder<LegalBloc, LegalState>(
              builder: (context, state) {
                return SimpleLoader(
                  isLoading: state.isLoaded,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(title: Text(loc.title), pinned: true),
                      SliverPadding(
                        padding: const EdgeInsets.all(24.0),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonSettingsTitle(
                                onTap: () => context.read<LegalBloc>().add(const LegalEvent.openPolicy()),
                                title: loc.policy_label,
                                icon: Icons.policy,
                              ),
                              const Divider(),
                              CommonSettingsTitle(
                                onTap: () => context.read<LegalBloc>().add(const LegalEvent.openTerms()),
                                title: loc.terms_label,
                                icon: Icons.rule,
                              ),
                              const Divider(),
                              CommonSettingsTitle(
                                onTap: () => context.read<LegalBloc>().add(const LegalEvent.openGdpr()),
                                title: loc.gdpr_label,
                                icon: Icons.euro,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
