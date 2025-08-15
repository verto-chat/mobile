import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

Future<void> showGallery(
  BuildContext context,
  List<String> imageUrls, {
  void Function(int index)? onSwipe,
  int initialIndex = 0,
}) async {
  StreamController<Widget> overlayController = StreamController<Widget>.broadcast();

  await SwipeImageGallery<dynamic>(
    context: context,
    children: imageUrls.map((i) => CachedNetworkImage(imageUrl: i)).toList(),
    initialIndex: initialIndex,
    heroProperties: imageUrls.map((i) => ImageGalleryHeroProperties(tag: i)).toList(),
    onSwipe: (index) {
      overlayController.add(OverlayExample(title: '${index + 1}/${imageUrls.length}'));
      onSwipe?.call(index);
    },
    overlayController: overlayController,
    initialOverlay: OverlayExample(title: '${initialIndex + 1}/${imageUrls.length}'),
    backgroundOpacity: 1,
    backgroundColor: Theme.of(context).colorScheme.surface,
    hideStatusBar: false,
    useSafeArea: false,
  ).show();

  overlayController.close();
}

class OverlayExample extends StatelessWidget {
  const OverlayExample({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: colorScheme.onSurface.withAlpha(50),
              padding: const EdgeInsets.all(16.0),
              child: Text(title, style: textTheme.titleMedium!.copyWith(color: colorScheme.onSurface)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: colorScheme.onSurface, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
