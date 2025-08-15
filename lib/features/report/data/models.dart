import 'package:json_annotation/json_annotation.dart';

import '../domain/entities.dart';

part 'models.g.dart';

enum TargetTypeDto {
  advert,
  chatMessage;

  static TargetTypeDto fromEntity(TargetType targetType) {
    return switch (targetType) {
      TargetType.advert => TargetTypeDto.advert,
      TargetType.chatMessage => TargetTypeDto.chatMessage,
    };
  }
}

enum ReportReasonDto {
  spam,
  inappropriate,
  abuse,
  other;

  static ReportReasonDto fromEntity(ReportReason reason) {
    return switch (reason) {
      ReportReason.spam => ReportReasonDto.spam,
      ReportReason.inappropriate => ReportReasonDto.inappropriate,
      ReportReason.abuse => ReportReasonDto.abuse,
      ReportReason.other => ReportReasonDto.other,
    };
  }
}

@JsonSerializable()
class ReportRequestDto {
  ReportRequestDto({required this.targetType, required this.targetId, required this.reason, required this.description});

  final String targetId;
  final TargetTypeDto targetType;
  final ReportReasonDto reason;
  final String? description;

  factory ReportRequestDto.fromJson(Map<String, dynamic> json) => _$ReportRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRequestDtoToJson(this);
}
