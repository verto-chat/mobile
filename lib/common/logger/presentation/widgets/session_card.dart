import 'package:flutter/material.dart';

import '../../entities/entities.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.data, required this.onShareTap});

  final SessionInfo data;
  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              '${data.date} | ${data.level ?? "no error"}',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onShareTap,
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.share_outlined, size: 24)),
          ),
        ],
      ),
    );
  }
}
