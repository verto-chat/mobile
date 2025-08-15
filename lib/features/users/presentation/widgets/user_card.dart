import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, required this.onTap});

  final UserInfo user;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            CustomAvatar(
              id: user.id,
              avatarUrl: user.avatarUrl,
              name: user.firstName,
            ),
            const SizedBox(width: 16),
            Text(_getUserName(user)),
          ],
        ),
      ),
    );
  }

  String _getUserName(UserInfo user) => '${user.firstName} ${user.lastName ?? ''}'.trim();
}
