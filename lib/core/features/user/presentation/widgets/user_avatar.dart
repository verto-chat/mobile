import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../common/presentation/widgets/custom_shimmer.dart';
import '../../domain/domain.dart';

const _colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

Color getUserAvatarNameColor(Object id) {
  final index = id.hashCode % _colors.length;
  return _colors[index];
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.radius = 20, required this.isShimmerLoading});

  final UserInfo user;
  final double radius;
  final bool isShimmerLoading;

  @override
  Widget build(BuildContext context) {
    if (isShimmerLoading) {
      return CustomShimmer(child: CircleAvatar(radius: radius));
    }

    final hasImage = user.thumbnail != null;

    return CircleAvatar(
      backgroundColor: hasImage ? Colors.transparent : getUserAvatarNameColor(user.id),
      backgroundImage: hasImage ? CachedNetworkImageProvider(user.thumbnail!) : null,
      radius: radius,
      child: !hasImage
          ? Text(
              _getInitials(user).toUpperCase(),
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white, fontSize: radius * 0.8),
            )
          : null,
    );
  }

  String _getInitials(UserInfo user) {
    if (user.firstName.isEmpty) return "";

    var initials = user.firstName.substring(0, 1);

    if (user.lastName?.isNotEmpty ?? false) {
      initials = initials + user.lastName!.substring(0, 1);
    }

    return initials;
  }
}
