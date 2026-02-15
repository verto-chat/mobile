part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.started(DomainId chatId) = _Started;

  const factory ChatEvent.send({required String text}) = _Send;

  const factory ChatEvent.onEndReached(Completer<void>? completer) = _OnEndReached;

  const factory ChatEvent.addAttachment() = _AddAttachment;

  const factory ChatEvent.tapMessage(Message message) = _TapMessage;

  const factory ChatEvent.longTapMessage(Message message) = _LongTapMessage;

  const factory ChatEvent.voiceCompleted({
    required String originalLanguageCode,
    required String translatedLanguageCode,
    required String filePath,
    required Duration duration,
  }) = _VoiceCompleted;

  const factory ChatEvent.playTts(MessageID id, {required Completer<void> completer}) = _PlayTts;

  // const factory ChatEvent.loadPreview(TextMessage message, PreviewData previewData) = _LoadPreview;
}
