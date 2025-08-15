import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../router/app_router.dart';
import '../../domain/domain.dart';
import '../pages/select_chat_type_sheet.dart';

part 'chats_bloc.freezed.dart';
part 'chats_event.dart';
part 'chats_state.dart';

const int _limit = 10;

class ChatsBloc extends ContextBloc<ChatsEvent, ChatsState> {
  final IChatsRepository _chatsRepository;
  final DomainId? advertId;
  final ILogger _logger;

  late final StreamSubscription<int> _roomsSubscription;

  ChatsBloc(BuildContext context, this.advertId, this._chatsRepository, this._logger)
    : super(ChatsState(pagingState: PagingState()), context) {
    on<_FetchNextPage>(_onFetchNextPage);
    on<_Refresh>(_onRefresh);
    on<_CreateChat>(_onCreateChat);

    _roomsSubscription = _chatsRepository
        .onChatsChanges(_limit)
        .listen(
          (rooms) {
            add(const ChatsEvent.refresh());
          },
          onError: (dynamic error) {
            _logger.log(LogLevel.error, "Failed to get chats changes", exception: error);
          },
        );
  }

  @override
  Future<void> close() async {
    await _roomsSubscription.cancel();
    return super.close();
  }

  Future<void> _onFetchNextPage(_FetchNextPage event, Emitter<ChatsState> emit) async {
    final pagingState = state.pagingState;

    if (pagingState.isLoading) return;

    emit(state.copyWith(pagingState: pagingState.copyWith(isLoading: true, error: null)));

    final lastChatId = pagingState.keys?.lastOrNull;

    final result = advertId != null
        ? await _chatsRepository.getAdvertChats(_limit, languageCode, advertId!, lastChatId: lastChatId)
        : await _chatsRepository.getChats(_limit, languageCode, lastChatId: lastChatId);

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
  }

  void _onRefresh(_Refresh event, Emitter<ChatsState> emit) {
    emit(state.copyWith(pagingState: PagingState()));

    add(const ChatsEvent.fetchNextPage());
  }

  Future<void> _onCreateChat(_CreateChat event, Emitter<ChatsState> emit) async {
    final result = await showModalBottomSheet<ChatType>(
      context: context,
      builder: (BuildContext context) => const SelectChatTypeSheet(),
    );

    if (!context.mounted) return;

    if (result == ChatType.p2p) {
      context.router.push(const CreateDirectChatRoute());
    }
  }
}
