import 'package:flutter/material.dart';

import '../utils/utils.dart';

class LayoutByPixelsBuilder extends StatelessWidget {
  const LayoutByPixelsBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, int widthInPx, int heightInPx) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final view = View.of(context);

        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final widthInPx = width.isNaN || width.isInfinite ? view.display.size.width : width.toPx(context);
        final heightInPx = height.isNaN || height.isInfinite ? view.display.size.height : height.toPx(context);

        return builder(context, widthInPx.toInt(), heightInPx.toInt());
      },
    );
  }
}
