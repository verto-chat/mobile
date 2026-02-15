import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class EditBorderedAvatar extends StatelessWidget {
  const EditBorderedAvatar({
    super.key,
    required this.avatarRadius,
    required this.userInfo,
    this.onEditTap,
    required this.isShimmerLoading,
  });

  final double avatarRadius;
  final UserInfo userInfo;
  final bool isShimmerLoading;
  final GestureTapCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final borderThickness = 4.0;
    final borderSize = (avatarRadius * 2.0) + (borderThickness * 2.0);

    final smallInnerSize = 36.0;
    final smallBorderSize = smallInnerSize + (borderThickness * 2.0);

    return Container(
      width: borderSize,
      height: borderSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderSize / 2.0),
      ),
      child: Stack(
        children: [
          Center(
            child: UserAvatar(radius: avatarRadius, user: userInfo, isShimmerLoading: isShimmerLoading),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 10),
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: smallBorderSize,
                  height: smallBorderSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(smallBorderSize / 2.0),
                  ),
                  child: Center(
                    child: Container(
                      width: smallInnerSize,
                      height: smallInnerSize,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 24),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
