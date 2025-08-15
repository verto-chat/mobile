import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../domain/domain.dart';
import '../manager/chats_bloc.dart';
import '../widgets/widgets.dart';

class BaseChatsPage extends StatelessWidget {
  const BaseChatsPage({super.key, required this.name, this.advertId});

  final DomainId? advertId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatsBloc(context, advertId, context.read(), context.read()),
      child: BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
          return Scaffold(
            body: RefreshIndicator(
              edgeOffset: MediaQuery.of(context).padding.top + kToolbarHeight,
              onRefresh: () async => context.read<ChatsBloc>().add(const ChatsEvent.refresh()),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(title: Text(name), centerTitle: advertId == null),
                  PagedSliverList<DomainId?, Chat>.separated(
                    state: state.pagingState,
                    fetchNextPage: () => context.read<ChatsBloc>().add(const ChatsEvent.fetchNextPage()),
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                        return ChatCard(
                          onTap: (chatId, chatName) {
                            context.router.push(ChatRoute(chatId: chatId, name: chatName));
                          },
                          chat: item,
                          isAdvertChats: advertId != null,
                        );
                      },
                      animateTransitions: true,
                      firstPageErrorIndicatorBuilder: (_) => TryAgainButton(
                        tryAgainAction: () => context.read<ChatsBloc>().add(const ChatsEvent.refresh()),
                      ),
                      newPageErrorIndicatorBuilder: (context) {
                        return LastPageErrorMessageView(
                          onTap: () => context.read<ChatsBloc>().add(const ChatsEvent.fetchNextPage()),
                        );
                      },
                      noItemsFoundIndicatorBuilder: (_) {
                        final loc = context.appTexts.chats.chats_page.no_items_stub;
                        return NoItemsStub(title: loc.title, description: loc.description);
                      },
                      firstPageProgressIndicatorBuilder: (_) => const DelayedSkeleton(child: _InitialSkeleton()),
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InitialSkeleton extends StatelessWidget {
  const _InitialSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(5 * 2 - 1, (index) {
          return index.isEven ? ChatCard.skeleton() : const Divider();
        }),
      ],
    );
  }
}
