import 'package:flutter/material.dart';

class CommonSelectTile extends StatelessWidget {
  const CommonSelectTile({super.key, required this.onTap, required this.title, required this.icon});

  factory CommonSelectTile.fromIcons({
    Key? key,
    required void Function() onTap,
    required String title,
    required IconData icon,
  }) {
    return CommonSelectTile(key: key, onTap: onTap, title: title, icon: Icon(icon));
  }

  final void Function() onTap;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: textTheme.labelLarge, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
