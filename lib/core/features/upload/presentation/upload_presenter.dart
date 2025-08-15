import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/common.dart';
import '../../../../i18n/translations.g.dart';
import '../../../core.dart';

Future<ImageSource?> selectImage(BuildContext context) async {
  final cameras = await availableCameras();

  if (!context.mounted) return null;

  final cameraIsAvailable = cameras.isNotEmpty;

  final imageSource = await _getSource(context, cameraIsAvailable);

  if (imageSource == null) return null;

  final permissionType = imageSource == ImageSource.camera ? PermissionType.camera : PermissionType.photos;

  if (await PermissionService.isPermanentlyDenied(permissionType)) {
    if (!context.mounted) return null;
    await DialogPresenter.showPermissionDeniedDialog(context, permissionType);
    return null;
  }

  return imageSource;
}

Future<ImageSource?> _getSource(BuildContext context, bool cameraIsAvailable) {
  final loc = context.appTexts.core.upload.select_photo.select_source_photo;

  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) {
      return SelectSheetContainer(
        children: [
          CommonSelectTile.fromIcons(
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            title: loc.from.gallery,
            icon: Icons.photo_library,
          ),
          if (cameraIsAvailable) ...[
            const Divider(),
            CommonSelectTile.fromIcons(
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
              title: loc.from.camera,
              icon: Icons.camera_alt,
            ),
          ],
        ],
      );
    },
  );
}
