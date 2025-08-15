import 'package:flutter/material.dart';

extension DoubleExtensions on double {
  double toPx(BuildContext context) {
    final view = View.of(context);

    final ratio = view.devicePixelRatio;

    return this * ratio;
  }
}
