import 'package:flutter/widgets.dart';

import 'dialog_action_info.dart';

class DialogInfo<T extends Enum> {
  DialogInfo({
    this.titleAlignment = Alignment.center,
    required this.title,
    required this.description,
    required this.actions,
    this.subtitle,
  });

  final Alignment titleAlignment;
  final String title;
  final String description;
  final String? subtitle;
  final List<DialogActionInfo<T>> actions;
}
