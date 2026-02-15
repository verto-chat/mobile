import 'package:openapi/openapi.dart';

import '../../../../common/common.dart';
import '../../domain/entities/legal_info.dart';
import '../../domain/repositories/legal_repository.dart';

class LegalRepository implements ILegalRepository {
  final RegulationsApi _api;
  final SafeDio _safeDio;

  LegalInfo? _cachedInfo;

  LegalRepository(this._api, this._safeDio);

  @override
  Future<DomainResultDErr<LegalInfo>> getInfo({required String languageCode}) async {
    if (_cachedInfo != null && _cachedInfo!.languageCode == languageCode) {
      return Success(data: _cachedInfo!);
    }

    final apiResult = await _safeDio.execute(() => _api.getRegulations());

    switch (apiResult) {
      case ApiSuccess(:final data):
        final legalInfo = data.toEntity();

        _cachedInfo = legalInfo;

        return Success(data: legalInfo);
      case ApiError():
        return Error(errorData: apiResult.toDomain());
    }
  }
}

extension _LegalInfoDtoExtensions on LegalInfoDto {
  LegalInfo toEntity() =>
      LegalInfo(policyUrl: policyUrl, termsUrl: termsUrl, gdprUrl: gdprUrl, languageCode: languageCode);
}
