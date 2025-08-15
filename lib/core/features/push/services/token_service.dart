import 'package:flutter/foundation.dart';

import '../../../../common/common.dart';
import '../../../../features/features.dart';
import '../../../core.dart';

class TokenService {
  final IAuthRepository _authProvider;
  final PushProvider _pushProvider;
  final ITokenRepository _pushRepository;

  String? _fcmToken;

  TokenService(this._pushRepository, this._authProvider, this._pushProvider) {
    _authProvider.isStatusChanged.listen(_onStatusChanged);
  }

  Future<void> start() async {
    var hasPermission = await PermissionService.requestNotificationPermission();

    if (!hasPermission) return;

    _fcmToken = await _pushProvider.getToken();

    if (kDebugMode) print("FCM Token: $_fcmToken");

    if (_fcmToken == null) return;

    await _pushRepository.actualize(token: _fcmToken!);
  }

  void changeLanguage(String languageCode) {
    if (_fcmToken == null) return;

    _actualize(languageCode, _fcmToken!);
  }

  void _onStatusChanged(AuthStatus status) async {
    if (_fcmToken == null) return;

    switch (status) {
      case Authenticated():
        _actualize(languageCode, _fcmToken!);
      case LoggedOut():
        _pushRepository.archive(token: _fcmToken!);
    }
  }

  void _actualize(String langCode, String fcmToken) {
    _pushRepository.actualize(token: fcmToken);
  }
}
