import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../i18n/translations.g.dart';
import '../manager/chat_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.chatId});

  final DomainId chatId;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.chats.chat_page;

    return BlocProvider(
      create: (_) => ChatBloc(context, context.read(), context.read(), context.read())..add(ChatEvent.started(chatId)),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(switch (state) {
                NotInitilized() => "",
                Initilized() => state.chat.name ?? "",
                Failure() => "",
              }),
            ),
            body: switch (state) {
              NotInitilized() => const Center(child: CircularProgressIndicator()),
              Initilized() => ChatContent(state: state),
              Failure() => Center(child: Text(loc.failure)),
            },
          );
        },
      ),
    );
  }
}
