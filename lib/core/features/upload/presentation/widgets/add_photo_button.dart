import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';

class AddPhotoButton extends StatelessWidget {
  const AddPhotoButton({
    super.key,
    required this.onTap,
    this.padding = const EdgeInsets.all(24.0),
    this.iconSize = 32,
    this.labelStyle,
  });

  final GestureTapCallback onTap;
  final EdgeInsets padding;
  final double iconSize;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.core.upload.add_photo_button;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, size: iconSize),
                  Text(loc.add_photo, style: labelStyle ?? Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
