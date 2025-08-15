part of 'chats_bloc.dart';

@freezed
sealed class ChatsState with _$ChatsState {
  const factory ChatsState({required PagingState<DomainId?, Chat> pagingState}) = _ChatsState;
}
