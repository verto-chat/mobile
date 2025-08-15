import 'package:flutter/material.dart';

class CommonSettingsTitle extends StatelessWidget {
  const CommonSettingsTitle({super.key, required this.onTap, required this.title, required this.icon, this.value});

  final void Function()? onTap;
  final String title;
  final String? value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = onTap != null
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.outlineVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),

            Text(title, style: textTheme.labelLarge?.copyWith(color: color)),

            if (value != null && value!.isNotEmpty) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  value!,
                  style: textTheme.labelLarge?.copyWith(color: color),
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(width: 8),
            ] else
              const Spacer(),

            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
