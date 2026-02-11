import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../../features.dart';
import '../manager/profile_bloc.dart';
import 'select_language_sheet.dart';
import 'select_theme_sheet.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile;

    final topPadding = MediaQuery.of(context).padding.top;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => createProfileBloc(context)),
        BlocProvider(create: (_) => LangBloc(context, context.read())),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SimpleLoader(
            isLoading: state.isLoading,
            child: RefreshIndicator(
              displacement: topPadding + 40,
              edgeOffset: topPadding,
              onRefresh: () {
                final completer = Completer<void>();
                context.read<ProfileBloc>().add(ProfileEvent.load(completer: completer));
                return completer.future;
              },
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  _HeaderAll(state: state),

                  ListTile(
                    onTap: () => context.read<ProfileBloc>().add(const ProfileEvent.editProfile()),
                    title: Text(loc.edit_profile_label),
                    leading: const Icon(Icons.edit),
                  ),

                  ListTile(
                    onTap: () => context.router.push(const SafetyRoute()),
                    title: Text(loc.safety_label),
                    leading: const Icon(Icons.shield),
                  ),

                  const _LanguageSettingsTile(),

                  const _ThemeSettingsTile(),

                  ListTile(
                    onTap: () => context.router.push(FeedbackRoute()),
                    title: Text(loc.feedback_label),
                    leading: const Icon(Icons.feedback),
                  ),

                  ListTile(
                    onTap: () => context.router.push(const LegalRoute()),
                    title: Text(loc.legal_label),
                    leading: const Icon(Icons.policy),
                  ),

                  ListTile(
                    onTap: () => context.read<ProfileBloc>().add(const ProfileEvent.logout()),
                    title: Text(loc.logout_label),
                    leading: const Icon(Icons.logout),
                  ),

                  SmartAdInlineBanner(adUnitId: context.read<IAdMobId>().profileBannerId),
                  const SizedBox(height: 48),
                  Center(child: ServiceButton(version: state.version)),

                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderAll extends StatelessWidget {
  const _HeaderAll({required this.state});

  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile.profile_page.plan;

    final userInfo = state.userInfo;

    final displayName = userInfo.lastName?.isNotEmpty ?? false
        ? '${userInfo.firstName} ${userInfo.lastName!.substring(0, 1).toUpperCase()}.'
        : userInfo.firstName;

    return DrawerHeader(
      child: Row(
        spacing: 12,
        children: [
          Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(radius: 40, user: userInfo, isShimmerLoading: state.isShimmerLoading),

              Text(displayName, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),

          Expanded(
            child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                final sub = state.subscription;

                return Column(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      loc.plan_name(planName: sub.plan.name),
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    // if (sub.recommendUpgrade)
                    //   TextButton.icon(
                    //     onPressed: () => context.router.push(const SupposeSubscriptionRoute()),
                    //     label: Text(loc.upgrade),
                    //     icon: const Icon(Icons.upgrade),
                    //   ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.credits_count(n: sub.creditsBalance),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.secondary),
                        ),
                        IconButton.filled(
                          onPressed: () => context.router.push(const BuyProductsRoute()),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSettingsTile extends StatelessWidget {
  const _LanguageSettingsTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangBloc, LangState>(
      builder: (context, state) {
        return ListTile(
          onTap: () => _showLanguageSelectionDialog(context),
          title: Text(context.appTexts.profile.language_label),
          leading: const Icon(Icons.language),
          trailing: Text(getLocaleName(state.selectedLocale)),
        );
      },
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SelectLanguageSheet(
          onLanguageChanged: (locale) {
            context.read<LangBloc>().add(LangEvent.changeLanguage(locale: locale));
            context.read<TokenService>().changeLanguage(locale.languageTag);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _ThemeSettingsTile extends StatelessWidget {
  const _ThemeSettingsTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return ListTile(
          onTap: () => _showThemeModeSelectionDialog(context),
          title: Text(context.appTexts.profile.theme.title),
          leading: const Icon(Icons.color_lens),
          trailing: Text(getThemeModeName(state.themeMode, context)),
        );
      },
    );
  }

  void _showThemeModeSelectionDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SelectThemeSheet(
          onThemeModeChanged: (t) {
            context.read<AppBloc>().add(AppEvent.changeThemeMode(t));
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
