import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../core/core.dart';
import '../features/features.dart';
import '../features/feedback/domain/domain.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final IAuthRepository _authService;
  final LangRepository _langRepository;

  AppRouter(this._authService, this._langRepository);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      children: [
        AutoRoute(page: ChatsRoute.page, path: 'chats'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),

    AutoRoute(page: SelectLanguageRoute.page, path: '/selectLanguage'),
    AutoRoute(page: SignInRoute.page, path: '/signIn'),
    AutoRoute(page: ForgotPasswordRoute.page, path: '/forgotPassword'),
    AutoRoute(page: CodeRoute.page, path: '/code'),
    AutoRoute(page: NewPasswordRoute.page, path: '/newPassword'),
    AutoRoute(page: SignUpRoute.page, path: '/signUp'),
    AutoRoute(page: EditProfileRoute.page, path: '/editProfile'),
    AutoRoute(page: SafetyRoute.page, path: '/safety'),

    AutoRoute(page: ChatRoute.page, path: '/chat'),
    AutoRoute(
      page: CreateChatRoute.page,
      path: '/createChat',
      type: const RouteType.cupertino(),
      children: [
        RedirectRoute(path: '', redirectTo: SelectChatTypeRoute.name),
        AutoRoute(page: SelectChatTypeRoute.page, path: 'selectChatType', type: const RouteType.cupertino()),
        AutoRoute(page: CreateLocalChatRoute.page, path: 'createLocalChat', type: const RouteType.cupertino()),
        AutoRoute(page: CreateDirectChatRoute.page, path: 'createDirectChat', type: const RouteType.cupertino()),
      ],
    ),

    AutoRoute(page: LegalRoute.page, path: '/legal'),
    AutoRoute(page: FeedbackRoute.page, path: '/feedback'),

    // in-app
    // AutoRoute(page: SupposeSubscriptionRoute.page, path: '/supposeSubscription'),
    // AutoRoute(page: SupposePromoteRoute.page, path: '/supposePromote'),
    AutoRoute(page: SelectSubscriptionRoute.page, path: '/selectSubscription'),
    AutoRoute(page: BuyProductsRoute.page, path: '/buyProducts'),
  ];

  final HashSet<String> _ignoredRoutes = HashSet.from([
    SignInRoute.name,
    SignUpRoute.name,
    SelectLanguageRoute.name,
    ForgotPasswordRoute.name,
    CodeRoute.name,
    NewPasswordRoute.name,
  ]);

  @override
  late final List<AutoRouteGuard> guards = [
    AutoRouteGuard.simple((resolver, router) {
      final isAuthenticated = switch (_authService.status) {
        Authenticated() => true,
        LoggedOut() => false,
      };

      final isCanSetLocale = _langRepository.isCanSetLocale;

      if (isAuthenticated && isCanSetLocale || _ignoredRoutes.contains(resolver.routeName)) {
        resolver.next();
      } else if (!isCanSetLocale) {
        router.replaceAll([
          SelectLanguageRoute(
            onResult: (didSetLocale) {
              if (didSetLocale) {
                router.replaceAll([const SignInRoute()]);
              }
            },
          ),
        ]);
      } else {
        router.replaceAll([const SignInRoute()]);
      }
    }),
  ];
}

typedef ResultCallback = void Function(bool success);
