import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';

class VoiceBarComposerWrapper extends StatefulWidget {
  /// Optional left position.
  final double? left;

  /// Optional right position.
  final double? right;

  /// Optional top position.
  final double? top;

  /// Optional bottom position.
  final double? bottom;

  /// Optional X blur value for the background (if using glassmorphism).
  final double? sigmaX;

  /// Optional Y blur value for the background (if using glassmorphism).
  final double? sigmaY;

  /// Background color of the composer container.
  final Color? backgroundColor;

  final Widget child;

  const VoiceBarComposerWrapper({
    super.key,
    required this.child,
    this.left = 0,
    this.right = 0,
    this.top,
    this.bottom = 0,
    this.sigmaX = 20,
    this.sigmaY = 20,
    this.backgroundColor,
  });

  @override
  State<VoiceBarComposerWrapper> createState() => _ComposerState();
}

class _ComposerState extends State<VoiceBarComposerWrapper> {
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(covariant VoiceBarComposerWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  Widget build(BuildContext context) {
    final sigmaX = widget.sigmaX ?? 0;
    final sigmaY = widget.sigmaY ?? 0;

    final shouldUseBackdropFilter = sigmaX > 0 || sigmaY > 0;

    final theme = context.select(
      (ChatTheme t) => (
        bodyMedium: t.typography.bodyMedium,
        onSurface: t.colors.onSurface,
        primary: t.colors.primary,
        surfaceContainerHigh: t.colors.surfaceContainerHigh,
        surfaceContainerLow: t.colors.surfaceContainerLow,
      ),
    );

    final content = Container(
      key: _key,
      color:
          widget.backgroundColor ??
          (shouldUseBackdropFilter ? theme.surfaceContainerLow.withValues(alpha: 0.8) : theme.surfaceContainerLow),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),

        child: widget.child,
      ),
    );

    return Positioned(
      left: widget.left,
      right: widget.right,
      top: widget.top,
      bottom: widget.bottom,
      child: ClipRect(
        child: shouldUseBackdropFilter
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                child: content,
              )
            : content,
      ),
    );
  }

  void _measure() {
    if (!mounted) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final height = renderBox.size.height;
      final bottomSafeArea = MediaQuery.of(context).padding.bottom;

      context.read<ComposerHeightNotifier>().setHeight(height - bottomSafeArea);
    }
  }
}
