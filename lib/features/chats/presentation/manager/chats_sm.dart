import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../common/common.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';

part 'chats_sm.freezed.dart';

@freezed
sealed class ChatsState with _$ChatsState {
  const factory ChatsState({required PagingState<DomainId?, Chat> pagingState}) = _ChatsState;
}

const int _limit = 10;

class ChatsStateManager extends ContextStateManager<ChatsState> {
  final IChatsRepository _chatsRepository;
  final ILogger _logger;

  late final StreamSubscription<int> _chatsSubscription;

  ChatsStateManager(BuildContext context, this._chatsRepository, this._logger)
    : super(ChatsState(pagingState: PagingState()), context) {
    _chatsSubscription = _chatsRepository
        .onChatsChanges(_limit)
        .listen(
          (chats) => refresh(),
          onError: (dynamic error) {
            _logger.log(LogLevel.error, "Failed to get chats changes", exception: error);
          },
        );
  }

  @override
  Future<void> close() async {
    await _chatsSubscription.cancel();
    return super.close();
  }

  Future<void> fetchNextPage() => handle((emit) async {
    final pagingState = state.pagingState;

    if (pagingState.isLoading) return;

    emit(state.copyWith(pagingState: pagingState.copyWith(isLoading: true, error: null)));

    final lastChatId = pagingState.keys?.lastOrNull;

    final result = await _chatsRepository.getChats(_limit, lastChatId: lastChatId);

    switch (result) {
      case Success():
        final newItems = result.data;
        final newKey = newItems.lastOrNull?.id;
        final isLastPage = newItems.isEmpty || newItems.length < _limit;

        emit(
          state.copyWith(
            pagingState: pagingState.copyWith(
              pages: [...?pagingState.pages, newItems],
              keys: [...?pagingState.keys, newKey],
              hasNextPage: !isLastPage,
              isLoading: false,
            ),
          ),
        );
      case Error():
        emit(state.copyWith(pagingState: pagingState.copyWith(isLoading: false, error: result.errorData)));
    }
  });

  void refresh() => handle((emit) async {
    emit(state.copyWith(pagingState: PagingState()));

    fetchNextPage();
  });

  void openChatContextMenu(Chat item) => handle((emit) async {
    final selected = await showMenu<ChatAction>(
      context: context,
      position: const RelativeRect.fromLTRB(200, 300, 100, 100),
      items: [
        PopupMenuItem(
          value: ChatAction.delete,
          child: ListTile(leading: const Icon(Icons.delete), title: Text(context.appTexts.chats.chats_page.delete_action)),
        ),
      ],
    );

    if (selected != null) {}
  });
}

enum ChatAction { delete }
