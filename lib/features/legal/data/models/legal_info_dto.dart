import 'package:json_annotation/json_annotation.dart';

import '../../domain/domain.dart';

part 'legal_info_dto.g.dart';

@JsonSerializable()
class LegalInfoDto {
  final String policyUrl;
  final String termsUrl;
  final String gdprUrl;
  final String languageCode;

  const LegalInfoDto({
    required this.policyUrl,
    required this.termsUrl,
    required this.gdprUrl,
    required this.languageCode,
  });

  factory LegalInfoDto.fromJson(Map<String, dynamic> json) => _$LegalInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LegalInfoDtoToJson(this);

  LegalInfo toEntity() =>
      LegalInfo(policyUrl: policyUrl, termsUrl: termsUrl, gdprUrl: gdprUrl, languageCode: languageCode);
}
