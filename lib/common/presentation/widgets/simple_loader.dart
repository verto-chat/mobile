import 'package:flutter/material.dart';

class SimpleLoader extends StatelessWidget {
  const SimpleLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.loaderBuilder,
    this.offset,
    this.opacity = 0,
    this.backgroundColor = Colors.black45,
    this.checkCanDismiss,
  });

  final bool isLoading;
  final Widget child;
  final Widget Function(BuildContext context)? loaderBuilder;
  final double opacity;
  final Color backgroundColor;
  final Offset? offset;
  final ValueGetter<bool>? checkCanDismiss;

  @override
  Widget build(BuildContext context) {
    final canDismiss = checkCanDismiss?.call() ?? true;

    return PopScope(
      canPop: canDismiss,
      onPopInvokedWithResult: canDismiss ? null : (canPop, _) => {},
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Visibility(
              visible: isLoading,
              child: Stack(
                children: [Opacity(opacity: opacity, child: Container(color: backgroundColor)), _buildLoader(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader(BuildContext context) {
    final completedLoader = loaderBuilder?.call(context) ?? const CircularProgressIndicator();

    if (offset != null) {
      return Positioned(left: offset!.dx, top: offset!.dy, child: completedLoader);
    }

    return Center(child: completedLoader);
  }
}
