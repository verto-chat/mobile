import '../../chats.dart';

class TextMessageMetadata {
  final ChatUser user;
  final String original;
  final bool hasTranslated;
  final String originalLanguageCode;
  final String? translatedLanguageCode;
  final bool sending;

  TextMessageMetadata({
    required this.user,
    required this.original,
    required this.hasTranslated,
    required this.originalLanguageCode,
    required this.translatedLanguageCode,
    this.sending = false,
  });

  factory TextMessageMetadata.fromJson(Map<String, dynamic> json) {
    return TextMessageMetadata(
      user: json['user'] as ChatUser,
      original: json['original'] as String,
      hasTranslated: json['hasTranslated'] as bool,
      originalLanguageCode: json['originalLanguageCode'] as String,
      translatedLanguageCode: json['translatedLanguageCode'] as String?,
      sending: json['sending'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user,
    'original': original,
    'hasTranslated': hasTranslated,
    'originalLanguageCode': originalLanguageCode,
    'translatedLanguageCode': translatedLanguageCode,
    'sending': sending,
  };
}
