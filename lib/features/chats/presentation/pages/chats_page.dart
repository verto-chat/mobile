import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:yx_state_provider/yx_state_provider.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../../chats/presentation/manager/chats_sm.dart';
import '../../../chats/presentation/widgets/widgets.dart';
import '../../../features.dart';

@RoutePage()
class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateManagerProvider(
      create: (_) => createChatsStateManager(context),
      child: ProviderStateBuilder<ChatsStateManager, ChatsState>(
        builder: (context, state, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.appTexts.chats.chats_page.title),
            ),
            body: RefreshIndicator(
              edgeOffset: MediaQuery.of(context).padding.top + kToolbarHeight,
              onRefresh: () async =>
                  context.read<ChatsStateManager>().refresh(),
              child: CustomScrollView(
                slivers: [
                  PagedSliverList<DomainId?, Chat>.separated(
                    state: state.pagingState,
                    fetchNextPage: () =>
                        context.read<ChatsStateManager>().fetchNextPage(),
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                        return Builder(
                          builder: (context) {
                            return ChatCard(
                              onTap: () => context.router.push(
                                ChatRoute(chatId: item.id),
                              ),
                              onLongTap: () => context
                                  .read<ChatsStateManager>()
                                  .openChatContextMenu(item),
                              chat: item,
                            );
                          },
                        );
                      },
                      animateTransitions: true,
                      firstPageErrorIndicatorBuilder: (_) => TryAgainButton(
                        tryAgainAction: () =>
                            context.read<ChatsStateManager>().refresh(),
                      ),
                      newPageErrorIndicatorBuilder: (context) {
                        return LastPageErrorMessageView(
                          onTap: () =>
                              context.read<ChatsStateManager>().fetchNextPage(),
                        );
                      },
                      noItemsFoundIndicatorBuilder: (_) {
                        final loc =
                            context.appTexts.chats.chats_page.no_items_stub;
                        return NoItemsStub(
                          title: loc.title,
                          description: loc.description,
                        );
                      },
                      firstPageProgressIndicatorBuilder: (_) =>
                          const DelayedSkeleton(child: _InitialSkeleton()),
                    ),
                    separatorBuilder: (context, index) => Divider(
                      indent: 60,
                      height: 1,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLowest,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: GlassButton(
                onTap: () => context.router.push(const SelectChatTypeRoute()),
                iconColor: Theme.of(context).colorScheme.primary,
                icon: CupertinoIcons.chat_bubble_2_fill,
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
