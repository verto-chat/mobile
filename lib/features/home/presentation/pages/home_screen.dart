import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            routes: [const ChatsRoute(), const SettingsRoute(), const ProfileRoute()],
            extendBody: true,
            //floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
            bottomNavigationBuilder: (_, tabsRouter) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: tabsRouter.activeIndex,
                    onTap: tabsRouter.setActiveIndex,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    items: [
                      BottomNavigationBarItem(label: loc.chats_label, icon: const Icon(Icons.chat)),
                      const BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings_outlined)),
                      BottomNavigationBarItem(label: loc.profile_label, icon: const Icon(Icons.person)),
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
