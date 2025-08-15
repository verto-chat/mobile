import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import 'base_chats_page.dart';

@RoutePage()
class AdvertChatsPage extends StatelessWidget {
  const AdvertChatsPage({super.key, required this.name, required this.advertId});

  final DomainId advertId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BaseChatsPage(advertId: advertId, name: name);
  }
}
