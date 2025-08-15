import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlurredImage extends StatelessWidget {
  const BlurredImage({super.key, required this.imageUrl, this.borderRadius});

  final String imageUrl;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final imageProvider = CachedNetworkImageProvider(imageUrl);

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12.0),
      child: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Image(image: imageProvider, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ),
          Align(
            alignment: Alignment.center,
            child: Image(image: imageProvider, fit: BoxFit.fitHeight, width: double.infinity, height: double.infinity),
          ),
        ],
      ),
    );
  }
}
