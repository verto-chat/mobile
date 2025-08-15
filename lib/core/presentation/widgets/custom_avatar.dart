import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/user/presentation/widgets/user_avatar.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({super.key, this.avatarUrl, required this.id, this.name, this.radius = 20});

  final String? avatarUrl;
  final String? name;
  final double radius;
  final Object id;

  @override
  Widget build(BuildContext context) {
    var color = Colors.transparent;

    color = getUserAvatarNameColor(id);

    final hasImage = avatarUrl != null;

    return CircleAvatar(
      backgroundColor: hasImage ? Colors.transparent : color,
      backgroundImage: hasImage ? CachedNetworkImageProvider(avatarUrl!) : null,
      radius: radius,
      child:
          !hasImage
              ? Text(name?.isEmpty ?? false ? '' : name![0].toUpperCase(), style: const TextStyle(color: Colors.white))
              : null,
    );
  }
}
