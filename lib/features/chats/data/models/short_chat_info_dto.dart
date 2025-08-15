import 'package:json_annotation/json_annotation.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';
import 'chat_dto.dart';

part 'short_chat_info_dto.g.dart';

@JsonSerializable()
class ShortChatInfoDto {
  final String name;
  final ChatTypeDto type;
  final String currentUserId;
  final String? advertId;

  ShortChatInfoDto(this.name, this.type, this.currentUserId, this.advertId);

  factory ShortChatInfoDto.fromJson(Map<String, dynamic> json) => _$ShortChatInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShortChatInfoDtoToJson(this);

  ShortChatInfo toEntity() {
    return ShortChatInfo(
      name: name,
      type: type.toEntity(),
      currentUserId: DomainId.fromString(id: currentUserId),
      advertId: advertId != null ? DomainId.fromString(id: advertId!) : null,
    );
  }
}
