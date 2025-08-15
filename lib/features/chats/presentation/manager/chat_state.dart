part of 'chat_bloc.dart';

@freezed
sealed class ChatState with _$ChatState {
  const factory ChatState.notInitilized() = NotInitilized;

  const factory ChatState.initilized({
    required ChatController chatController,
    required String currentUserId,
    required String title,
    required ChatType chatType,
    required DomainId? advertId,
  }) = Initilized;

  const factory ChatState.failure() = Failure;
}
