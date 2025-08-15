import 'package:freezed_annotation/freezed_annotation.dart';

part 'legal_info.freezed.dart';

@freezed
sealed class LegalInfo with _$LegalInfo {
  const factory LegalInfo(
      {required String policyUrl, required String termsUrl, required String gdprUrl, required String languageCode}) =
  _LegalInfo;
}
