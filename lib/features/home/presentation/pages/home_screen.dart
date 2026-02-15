import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../home.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.home;

    return HomeFeature(
      builder: (context, _) {
        return BlocProvider(
          create: (_) => createHomeBloc(context),
          lazy: false,
          child: AutoTabsScaffold(
            routes: [
              const ChatsRoute(),
              const SettingsRoute(),
              const ProfileRoute(),
            ],
            extendBody: true,
            bottomNavigationBuilder: (_, tabsRouter) {
              return GlassBottomBar(
                verticalPadding: MediaQuery.of(context).padding.bottom + 6,
                horizontalPadding: 24,
                barHeight: 58,
                selectedIconColor: Theme.of(context).colorScheme.primary,
                unselectedIconColor: Theme.of(context).colorScheme.onSurface,
                tabs: [
                  GlassBottomBarTab(
                    icon: Icons.chat_outlined,
                    selectedIcon: Icons.chat,
                    label: loc.chats_label,
                  ),
                  GlassBottomBarTab(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: loc.settings_label,
                  ),
                  GlassBottomBarTab(
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: loc.profile_label,
                  ),
                ],
                selectedIndex: tabsRouter.activeIndex,
                onTabSelected: (i) => tabsRouter.setActiveIndex(i),
              );
            },
          ),
        );
      },
    );
  }
}
