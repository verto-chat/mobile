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
            routes: [const ChatsRoute(), const ProfileRoute()],
            bottomNavigationBuilder: (_, tabsRouter) {
              return BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                items: [
                  BottomNavigationBarItem(label: loc.main_label, icon: const Icon(Icons.home)),
                  BottomNavigationBarItem(label: loc.favorites_label, icon: const Icon(Icons.bookmark)),
                  BottomNavigationBarItem(label: loc.my_adverts_label, icon: const Icon(Icons.add_box)),
                  BottomNavigationBarItem(label: loc.chats_label, icon: const Icon(Icons.chat)),
                  BottomNavigationBarItem(label: loc.profile_label, icon: const Icon(Icons.person)),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
