import 'package:permission_handler/permission_handler.dart';

enum PermissionType { camera, photos, location, locationAlways }

class PermissionService {
  static Future<bool> openSettings() {
    return openAppSettings();
  }

  static Future<bool> isPermanentlyDenied(PermissionType permissionType) async {
    final status = switch (permissionType) {
      PermissionType.location => await Permission.location.status,
      PermissionType.camera => await Permission.camera.status,
      PermissionType.photos => await Permission.photos.status,
      PermissionType.locationAlways => await Permission.locationAlways.status,
    };

    return status.isPermanentlyDenied;
  }

  static Future<bool> isDeniedOrPermanentlyDenied(PermissionType permissionType) async {
    final status = switch (permissionType) {
      PermissionType.location => await Permission.location.status,
      PermissionType.camera => await Permission.camera.status,
      PermissionType.photos => await Permission.photos.status,
      PermissionType.locationAlways => await Permission.locationAlways.status,
    };

    return status.isDenied || status.isPermanentlyDenied;
  }

  static Future<bool> canRequest(PermissionType permissionType) async {
    final status = switch (permissionType) {
      PermissionType.location => await Permission.location.status,
      PermissionType.camera => await Permission.camera.status,
      PermissionType.photos => await Permission.photos.status,
      PermissionType.locationAlways => await Permission.locationAlways.status,
    };

    return status.isDenied && !status.isPermanentlyDenied;
  }

  static Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.notification.request();
    }

    return status.isGranted;
  }
}
