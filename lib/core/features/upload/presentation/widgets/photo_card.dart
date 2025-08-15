import 'package:flutter/material.dart';

import '../../../../core.dart';
import '../manager/upload_file_bloc.dart';
import 'upload_photo_card.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    required this.photo,
    required this.onUploaded,
    required this.uploadFunction,
    required this.onLongPressed,
    required this.onRemoved,
  });

  final UploadedFile photo;
  final void Function(UploadedLocalFile loadFile, UploadedImageUrl uploadedPhoto) onUploaded;
  final UploadPhotoFunction uploadFunction;
  final void Function() onLongPressed;
  final void Function() onRemoved;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: GestureDetector(
        onLongPress: onLongPressed,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: switch (photo) {
                UploadedLocalFile() => UploadPhotoCard(
                  photo: photo as UploadedLocalFile,
                  onUploaded: onUploaded,
                  uploadFunction: uploadFunction,
                ),
                UploadedImageUrl(:final thumbnailImageUrl) => BlurredImage(imageUrl: thumbnailImageUrl),
                UploadedFileUrl() => const SizedBox.shrink(),
              },
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ColoredBox(color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.2)),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onRemoved,
                child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.close)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
