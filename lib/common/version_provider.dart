import 'package:package_info_plus/package_info_plus.dart';

class VersionProvider {
  VersionProvider._create({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  static Future<VersionProvider> create() async {
    final info = await PackageInfo.fromPlatform();

    return VersionProvider._create(version: info.version, buildNumber: info.buildNumber);
  }
}
