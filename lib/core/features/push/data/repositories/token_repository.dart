import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';

import '../../../../../common/common.dart';
import '../../../../core.dart';

class TokenRepository implements ITokenRepository {
  final DeviceApi _deviceTokenApi;
  final DeviceIdProvider _deviceIdProvider;
  final SafeDio _safeDio;

  TokenRepository(this._deviceTokenApi, this._deviceIdProvider, this._safeDio);

  @override
  Future<EmptyDomainResult> actualize({required String token}) async {
    final request = _createDeviceTokenRequest(token);

    if (request == null) return Error(errorData: const DomainErrorType.errorDefaultType());

    final apiResult = await _safeDio.execute(() => _deviceTokenApi.actualizeToken(deviceTokenRequestDto: request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> archive({required String token}) async {
    final apiResult = await _safeDio.execute(() => _deviceTokenApi.archiveToken(fcmToken: token));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  DeviceTokenRequestDto? _createDeviceTokenRequest(String token) {
    String? deviceId = _deviceIdProvider.deviceId;
    PlatformDto? platform;

    if (Platform.isIOS) {
      platform = PlatformDto.ios;
    }

    if (Platform.isAndroid) {
      platform = PlatformDto.android;
    }

    if (deviceId == null || platform == null) return null;

    return DeviceTokenRequestDto(fcmToken: token, platform: platform, isProduction: kReleaseMode, deviceId: deviceId);
  }
}
