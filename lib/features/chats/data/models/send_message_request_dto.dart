import 'package:json_annotation/json_annotation.dart';

part 'send_message_request_dto.g.dart';

@JsonSerializable()
class SendTextMessageRequestDto {
  final String chatId;
  final String originalText;

  SendTextMessageRequestDto({required this.chatId, required this.originalText});

  factory SendTextMessageRequestDto.fromJson(Map<String, dynamic> json) => _$SendTextMessageRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendTextMessageRequestDtoToJson(this);
}

@JsonSerializable()
class SendFileMessageRequestDto {
  final String chatId;
  final String fileUrl;
  final String fileName;
  final int fileSize;
  final String? mimeType;

  SendFileMessageRequestDto({
    required this.chatId,
    required this.fileUrl,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
  });

  factory SendFileMessageRequestDto.fromJson(Map<String, dynamic> json) => _$SendFileMessageRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendFileMessageRequestDtoToJson(this);
}

@JsonSerializable()
class SendImageMessageRequestDto {
  final String chatId;
  final String imageUrl;
  final String thumbnailImageUrl;
  final String fileName;
  final int fileSize;
  final String? mimeType;

  SendImageMessageRequestDto({
    required this.chatId,
    required this.imageUrl,
    required this.thumbnailImageUrl,
    required this.fileName,
    required this.fileSize,
    this.mimeType,
  });

  factory SendImageMessageRequestDto.fromJson(Map<String, dynamic> json) => _$SendImageMessageRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendImageMessageRequestDtoToJson(this);
}
