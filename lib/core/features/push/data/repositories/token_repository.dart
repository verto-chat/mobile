import 'dart:io';

import '../../../../../common/common.dart';
import '../../../../core.dart';
import '../models/models.dart';

class TokenRepository implements ITokenRepository {
  final TokenApi _deviceTokenApi;
  final DeviceIdProvider _deviceIdProvider;
  final SafeDio _safeDio;

  TokenRepository(this._deviceTokenApi, this._deviceIdProvider, this._safeDio);

  @override
  Future<EmptyDomainResult> actualize({required String token}) async {
    final request = _createDeviceTokenRequest(token);

    if (request == null) return Error(errorData: const DomainErrorType.errorDefaultType());

    final apiResult = await _safeDio.execute(() => _deviceTokenApi.actualize(request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> archive({required String token}) async {
    final apiResult = await _safeDio.execute(() => _deviceTokenApi.archive(token));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  DeviceTokenRequest? _createDeviceTokenRequest(String token) {
    String? deviceId = _deviceIdProvider.deviceId;
    PlatformDto? platform;

    if (Platform.isIOS) {
      platform = PlatformDto.ios;
    }

    if (Platform.isAndroid) {
      platform = PlatformDto.android;
    }

    if (deviceId == null || platform == null) return null;

    return DeviceTokenRequest(fcmToken: token, platform: platform, deviceId: deviceId);
  }
}
