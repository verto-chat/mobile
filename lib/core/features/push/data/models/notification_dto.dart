import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationDto {
  @JsonKey(name: "navigation_type", unknownEnumValue: AppNavigationActionDto.unknown)
  AppNavigationActionDto? navigationType;
  @JsonKey(name: "chat_id")
  String? chatId;

  NotificationDto({this.navigationType, this.chatId});

  factory NotificationDto.fromJson(Map<String, dynamic> json) => _$NotificationDtoFromJson(json);
}

enum AppNavigationActionDto {
  @JsonValue("1")
  chat,
  unknown,
}
