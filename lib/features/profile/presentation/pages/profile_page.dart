import 'dart:async';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../../features.dart';
import '../manager/profile_bloc.dart';
import '../widgets/widgets.dart';
import 'select_language_sheet.dart';
import 'select_theme_sheet.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile;

    final avatarRadius = 80.0;

    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = avatarRadius * 2 + 32 + topPadding;

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
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: headerHeight,
                    stretch: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: _Username(state.userInfo),
                      titlePadding: EdgeInsets.only(top: topPadding),
                      centerTitle: true,
                      collapseMode: CollapseMode.pin,
                      stretchModes: const [StretchMode.zoomBackground],
                      expandedTitleScale: 1,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          SizedBox(
                            height: headerHeight,
                            width: double.infinity,
                            child: state.isShimmerLoading
                                ? const ShimmerContainer()
                                : RepaintBoundary(
                                    child: ClipRect(
                                      child: ImageFiltered(
                                        imageFilter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                                        child: state.userInfo.thumbnail?.isNotEmpty ?? false
                                            ? CachedNetworkImage(imageUrl: state.userInfo.thumbnail!, fit: BoxFit.cover)
                                            : Container(color: getUserAvatarNameColor(state.userInfo.id)),
                                      ),
                                    ),
                                  ),
                          ),
                          Container(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2)),
                          _Header(state.userInfo, state.isShimmerLoading, avatarRadius),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0).copyWith(top: 0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          const _SubscriptionInfo(),
                          const Divider(),
                          CommonSettingsTitle(
                            onTap: () => context.read<ProfileBloc>().add(const ProfileEvent.editProfile()),
                            title: loc.edit_profile_label,
                            icon: Icons.edit,
                          ),
                          const Divider(),
                          CommonSettingsTitle(
                            onTap: () => context.router.push(const SafetyRoute()),
                            title: loc.safety_label,
                            icon: Icons.shield,
                          ),
                          const Divider(),
                          const _LanguageSettingsTile(),
                          const Divider(),
                          const _ThemeSettingsTile(),
                          const Divider(),
                          CommonSettingsTitle(
                            onTap: () => context.read<ProfileBloc>().add(const ProfileEvent.createSupportChat()),
                            title: loc.profile_page.create_support_chat,
                            icon: Icons.contact_support,
                          ),
                          const Divider(),
                          CommonSettingsTitle(
                            onTap: () => context.router.push(FeedbackRoute()),
                            title: loc.feedback_label,
                            icon: Icons.feedback,
                          ),
                          const Divider(),
                          CommonSettingsTitle(
                            onTap: () => context.router.push(const LegalRoute()),
                            title: loc.legal_label,
                            icon: Icons.policy,
                          ),
                          const Divider(),
                          CommonSettingsTitle(
                            onTap: () => context.read<ProfileBloc>().add(const ProfileEvent.logout()),
                            title: loc.logout_label,
                            icon: Icons.logout,
                          ),
                          const Divider(),
                          SmartAdInlineBanner(adUnitId: context.read<IAdMobId>().profileBannerId),
                          const SizedBox(height: 48),
                          Center(child: ServiceButton(version: state.version)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Username extends StatelessWidget {
  const _Username(this.userInfo);

  final UserInfo userInfo;

  @override
  Widget build(BuildContext context) {
    final displayName = userInfo.lastName?.isNotEmpty ?? false
        ? '${userInfo.firstName} ${userInfo.lastName!.substring(0, 1).toUpperCase()}.'
        : userInfo.firstName;

    return Align(
      alignment: Alignment.topCenter,
      child: Text(displayName, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.userInfo, this.isShimmerLoading, this.avatarRadius);

  final UserInfo userInfo;
  final bool isShimmerLoading;
  final double avatarRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(height: avatarRadius, color: Theme.of(context).colorScheme.surface),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: EditBorderedAvatar(
            avatarRadius: avatarRadius,
            userInfo: userInfo,
            isShimmerLoading: isShimmerLoading,
            onEditTap: () => context.read<ProfileBloc>().add(const ProfileEvent.uploadAvatar()),
          ),
        ),
      ],
    );
  }
}

class _SubscriptionInfo extends StatelessWidget {
  const _SubscriptionInfo();

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile.profile_page.subscription;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            final sub = state.subscription;

            return Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.subscription_name(subscriptionName: sub.subscriptionName),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
                Text(
                  loc.promotions_count(n: sub.singlePromotionLimit) +
                      (sub.subscriptionPromoteLimit != null
                          ? " + ${loc.sub_promotion_limit(count: sub.subscriptionPromoteLimit!)}"
                          : ""),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                if (sub.recommendUpgrade)
                  FilledButton.icon(
                    onPressed: () => context.router.push(const SupposeSubscriptionRoute()),
                    label: Text(loc.upgrade),
                    icon: const Icon(Icons.upgrade),
                  ),
                FilledButton.tonalIcon(
                  onPressed: () => context.router.push(const BuyProductsRoute()),
                  icon: const Icon(Icons.add),
                  label: Text(loc.buy_promotion),
                ),
              ],
            );
          },
        ),
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
        return CommonSettingsTitle(
          onTap: () => _showLanguageSelectionDialog(context),
          title: context.appTexts.profile.language_label,
          icon: Icons.language,
          value: getLocaleName(state.selectedLocale),
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
        return CommonSettingsTitle(
          onTap: () => _showThemeModeSelectionDialog(context),
          title: context.appTexts.profile.theme.title,
          icon: Icons.color_lens,
          value: getThemeModeName(state.themeMode, context),
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
