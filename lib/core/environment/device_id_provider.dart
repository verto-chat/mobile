import 'package:flutter_udid/flutter_udid.dart';

class DeviceIdProvider {
  DeviceIdProvider._create(this._deviceId);

  final String? _deviceId;

  String? get deviceId => _deviceId;

  static Future<DeviceIdProvider> create() async {
    final deviceId = await FlutterUdid.udid;

    return DeviceIdProvider._create(deviceId);
  }
}
