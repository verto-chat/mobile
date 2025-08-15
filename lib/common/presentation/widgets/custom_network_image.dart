import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'custom_shimmer.dart';

class CustomNetworkImage extends StatefulWidget {
  const CustomNetworkImage({
    super.key,
    required this.url,
    this.fit,
    this.width,
    this.height,
    required this.replyButtonColor,
  });

  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Color replyButtonColor;

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url,
      fit: widget.fit,
      height: widget.height,
      width: widget.width,
      placeholder: (context, url) => ShimmerContainer(height: widget.height, width: widget.width),
      errorWidget: (context, url, error) {
        return GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: Container(
            color: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.replay, color: widget.replyButtonColor, size: 32),
            ),
          ),
        );
      },
    );
  }
}

class CustomNetworkImageProvider extends CachedNetworkImageProvider {
  const CustomNetworkImageProvider(super.url, {super.errorListener});
}
