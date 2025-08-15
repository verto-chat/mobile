import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomVisibilityDetector extends StatelessWidget {
  const CustomVisibilityDetector({
    required this.child,
    required this.uniqueKey,
    required this.onVisibilityChanged,
    super.key,
  });

  final Key uniqueKey;
  final Widget child;
  final void Function(bool isVisible) onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        if (context.mounted) {
          onVisibilityChanged(info.visibleFraction == 1);
        }
      },
      key: uniqueKey,
      child: child,
    );
  }
}
