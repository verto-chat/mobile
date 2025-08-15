import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({super.key, required this.child, this.isText = false});

  factory CustomShimmer.text({Key? key, required Widget child}) => CustomShimmer(isText: true, child: child);

  final Widget child;
  final bool isText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = isText ? colorScheme.onSurface.withValues(alpha: 0.7) : colorScheme.shadow.withValues(alpha: 0.7);
    final highlightColor = isText
        ? colorScheme.onSurface.withValues(alpha: 0.3)
        : colorScheme.shadow.withValues(alpha: 0.3);

    return Shimmer.fromColors(baseColor: baseColor, highlightColor: highlightColor, child: child);
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({super.key, this.borderRadius, this.height, this.width});

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: height ?? 24,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
      ),
    );
  }
}
