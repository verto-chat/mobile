import 'dart:async';

import 'package:flutter/material.dart';

class DelayedSkeleton extends StatefulWidget {
  const DelayedSkeleton({super.key, required this.child, this.delay = const Duration(milliseconds: 500)});

  final Duration delay;
  final Widget child;

  @override
  State<DelayedSkeleton> createState() => _DelayedSkeletonState();
}

class _DelayedSkeletonState extends State<DelayedSkeleton> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _visible ? widget.child : const SizedBox.shrink();
  }
}
