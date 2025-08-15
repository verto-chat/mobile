import 'package:json_annotation/json_annotation.dart';

import '../domain/domain.dart';

part 'models.g.dart';

enum FeedbackTypeDto {
  bug,
  feature,
  category,
  question,
  general;

  static FeedbackTypeDto fromEntity(FeedbackType type) => switch (type) {
    FeedbackType.bug => FeedbackTypeDto.bug,
    FeedbackType.feature => FeedbackTypeDto.feature,
    FeedbackType.category => FeedbackTypeDto.category,
    FeedbackType.question => FeedbackTypeDto.question,
    FeedbackType.general => FeedbackTypeDto.general,
  };
}

@JsonSerializable()
class FeedbackRequestDto {
  FeedbackRequestDto({required this.type, required this.description});

  final FeedbackTypeDto type;
  final String description;

  factory FeedbackRequestDto.fromJson(Map<String, dynamic> json) => _$FeedbackRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackRequestDtoToJson(this);
}
