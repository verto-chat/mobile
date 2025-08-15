import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shadows: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface,
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          )
        ],
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(message),
    );
  }
}
