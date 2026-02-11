part of 'chat_bloc.dart';

@freezed
sealed class ChatState with _$ChatState {
  const factory ChatState.notInitilized() = NotInitilized;

  const factory ChatState.initilized({required ChatController chatController, required ShortChatInfo chat}) =
      Initilized;

  const factory ChatState.failure() = Failure;
}
