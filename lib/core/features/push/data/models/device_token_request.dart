import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_token_request.g.dart';

enum PlatformDto { ios, android }

@JsonSerializable()
class DeviceTokenRequest {
  DeviceTokenRequest({
    required this.fcmToken,
    required this.platform,
    this.isProduction = !kDebugMode,
    required this.deviceId,
  });

  final String fcmToken;
  final PlatformDto platform;
  final bool isProduction;
  final String deviceId;

  Map<String, dynamic> toJson() => _$DeviceTokenRequestToJson(this);

  factory DeviceTokenRequest.fromJson(Map<String, dynamic> json) => _$DeviceTokenRequestFromJson(json);
}
