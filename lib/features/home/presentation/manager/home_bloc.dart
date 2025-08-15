import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../router/app_router.dart';
import '../../../features.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends ContextBloc<HomeEvent, HomeState> {
  //final CheckVersion _checkVersion;
  final PushProvider _pushProvider;
  final PushActionNotificator _pushActionNotificator;
  final DeepLinksNotificator _deepLinksNotificator;

  late StreamSubscription<NotificationInfo> _pushSubscription;
  late StreamSubscription<DeepLinkInfo> _deepLinksSubscription;

  HomeBloc(BuildContext context, this._pushProvider, this._pushActionNotificator, this._deepLinksNotificator)
    : super(const HomeState.initial(), context) {
    on<_Started>(_onStarted);

    _pushSubscription = _pushActionNotificator.onNotificationAction.listen(_onPushReceived);
    _deepLinksSubscription = _deepLinksNotificator.onNotificationAction.listen(_onDeepLinkReceived);

    add(const HomeEvent.started());
  }

  Future<void> _onStarted(_Started event, Emitter<HomeState> emit) async {
    final initPushMessage = await _pushProvider.getInitialMessage();

    if (initPushMessage != null) _onPushReceived(initPushMessage);

    // await Future<void>.delayed(const Duration(seconds: 2));
    //
    // final storeUrl = await _checkVersion();
    //
    // if (storeUrl != null && storeUrl.isNotEmpty) {
    //   if (context.mounted) {
    //     _showNewVersionSheet(context, storeUrl);
    //   }
    // }
  }

  @override
  Future<void> close() {
    _pushSubscription.cancel();
    _deepLinksSubscription.cancel();
    return super.close();
  }

  //Future<void> _showNewVersionSheet(BuildContext context, String storeUrl) async {
  // final action = await VersionPresenter.showNewVersionSheet(context, storeUrl);
  //
  // if (action == NewVersionActionType.update) {
  //   locator<ExternalOpenUrl>().call(storeUrl);
  // }
  //}

  void _onPushReceived(NotificationInfo notification) {
    switch (notification.navigationType) {
      case AppNavigationAction.chat:
        _navigateToChat(notification);
      case AppNavigationAction.unknown:
      default:
        break;
    }
  }

  void _onDeepLinkReceived(DeepLinkInfo deepLinkInfo) {
    final uri = Uri.parse(deepLinkInfo.url);

    // 1) https://app.ovdix.com  -> host, scheme
    // 2) /advert/828e0307…  -> pathSegments
    final segs = uri.pathSegments; // [advert, 828e…]

    if (segs.length < 2) return;

    final section = segs[0]; // advert
    final id = segs[1]; // UUID

    if (section == 'advert') {
      _navigateToAdvert(DomainId.fromString(id: id));
    }
  }

  void _navigateToChat(NotificationInfo notification) {
    if (notification.chatId == null) return;

    final router = AutoRouter.of(context);

    final chatId = notification.chatId!;

    chatRoute() => ChatRoute(chatId: chatId);

    if (router.current.name == ChatRoute.name) {
      var pageInfo = router.stack.last;

      if ((pageInfo.child as ChatPage).chatId != chatId) {
        router.popAndPush(chatRoute());
      }
    } else {
      router.push(chatRoute());
    }
  }

  void _navigateToAdvert(DomainId advertId) {
    // final router = AutoRouter.of(context);
    //
    // advertRoute() => AdvertDetailRoute(id: advertId);
    //
    // if (router.current.name == AdvertDetailRoute.name) {
    //   var pageInfo = router.stack.last;
    //
    //   if ((pageInfo.child as AdvertDetailPage).id != advertId) {
    //     router.popAndPush(advertRoute());
    //   }
    // } else {
    //   router.push(advertRoute());
    // }
  }
}
