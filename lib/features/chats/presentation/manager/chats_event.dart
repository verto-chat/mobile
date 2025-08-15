part of 'chats_bloc.dart';

@freezed
class ChatsEvent with _$ChatsEvent {
  const factory ChatsEvent.refresh() = _Refresh;

  const factory ChatsEvent.fetchNextPage() = _FetchNextPage;

  const factory ChatsEvent.createChat() = _CreateChat;
}
